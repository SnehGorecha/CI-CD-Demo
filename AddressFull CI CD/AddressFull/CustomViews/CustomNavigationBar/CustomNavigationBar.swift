//
//  CustomNavigationBar.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class CustomNavigationBar: UIView {
    
    
    // MARK: OBJECTS & OUTLETS
    
    var didButtonLeftPressedBlock : (() -> Void)!
    var didButtonRightPressedBlock : (() -> Void)!
    var right_image : String?
    
    static let shared = CustomNavigationBar()
    
    fileprivate var _isWithBackOption : Bool?
    fileprivate var _isWithRightOption = true
    fileprivate var _isWithQROption = true
    fileprivate var _isWithDownloadOption = true
    
    var isWithBackOption: Bool? {
        get {
            return self._isWithBackOption
        }
        set {
            self._isWithBackOption = newValue
            self.manageBackButtonOption(isWithBackOption: newValue)
            
        }
    }
    
    var isWithRightOption: Bool {
        get {
            return self._isWithRightOption
        }
        set {
            self._isWithRightOption = newValue
            self.manageRightButtonOption(isWithRightOption: newValue)
            
        }
    }
    
    var isWithQROption: Bool {
        get {
            return self._isWithQROption
        }
        set {
            
            self._isWithQROption = newValue
            self.manageQRButtonOption(isWithQROption: newValue)
            
        }
    }
    
    @IBOutlet weak var btn_left: UIButton!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var btn_right: UIButton!
    @IBOutlet weak var navigation_bar_separator_view: UIView!
    @IBOutlet weak var btn_qr_code: UIButton!
    
    
    // MARK: VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    
    // MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.backgroundColor = .clear
        self.navigation_bar_separator_view.isHidden = true
        self.btn_left.removeText()
        self.btn_right.removeText()
    }
    
    
    // MARK: MANAGE BUTTONS
    
    func manageBackButtonOption(isWithBackOption: Bool?) {
        let data = UserDetailsModel.shared.image
        let profile_image = UIImage(data: data)
        
        if let isWithBackOption = isWithBackOption {
            self.btn_left.setImage(isWithBackOption
                                   ? UIImage(named: AssetsImage.back_arrow)?.withRenderingMode(.alwaysOriginal)
                                   : (profile_image ?? UIImage(named: AssetsImage.profile_placeholder))?.withRenderingMode(.alwaysOriginal),
                                   for: .normal)
            self.btn_left.isHidden = false
            self.btn_left.imageView?.contentMode = .scaleAspectFill
            self.btn_left.setupLayer(borderColor: isWithBackOption
                                                    ? .clear
                                                        : AppColor.primary_green(),
                                     borderWidth: 2,
                                     cornerRadius: self.btn_left.frame.height/2)
            
        } else {
            self.btn_left.isHidden = true
        }
    }
    
    func manageRightButtonOption(isWithRightOption: Bool) {
        DispatchQueue.main.async {
            self.btn_right.setImage(UIImage(named: self.right_image ??
                                             AssetsImage.notification_unselected)?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.btn_right.isHidden = !isWithRightOption
        }
    }
    
    func manageQRButtonOption(isWithQROption: Bool) {
        DispatchQueue.main.async {
            self.btn_qr_code.setImage(UIImage(named: AssetsImage.qr_scanner)?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.btn_qr_code.isHidden = !isWithQROption
        }
    }
    
    
    // MARK: OPEN QR CODE SCANNER
    
    func openScanner() {
        
        if let top_vc = UIApplication.topViewController() {
            if #available(iOS 14, *) {
                PermissionManager.shared.defaultAlertTitle = AppInfo.app_name
                PermissionManager.shared.checkPermission(for: [.camera], parentController: top_vc) {
                    
                    let vc = top_vc.getController(from: .scanner, controller: .scanner_vc) as! ScannerVC
                    DispatchQueue.main.async {
                        vc.hidesBottomBarWhenPushed = true
                        
                        vc.did_scan_block = { is_success,json_data in
                            if is_success {
                                if let organization_id = json_data?["organizationId"] as? String {
                                    top_vc.navigateTo(.organization_profile(id: organization_id,is_came_from_scanner: true))
                                }
                                
                            } else {
                                top_vc.showPopupAlert(title: Message.invalid_qr(),
                                                      message: nil,
                                                      leftTitle: nil,
                                                      rightTitle: LocalText.AlertButton().try_again(),
                                                      close_button_hidden: true,
                                                      didPressedLeftButton: nil,
                                                      didPressedRightButton: nil)
                            }
                        }
                        
                        top_vc.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    top_vc.showPopupAlert(title: AppInfo.app_name,
                                        message: Message.upgrade_your_os_version(),
                                        leftTitle: nil,
                                        rightTitle: LocalText.AlertButton().ok(),
                                        close_button_hidden: true,
                                        didPressedLeftButton: nil,
                                        didPressedRightButton: nil)
                }
            }
        }
    }
    
    
    // MARK: BUTTON'S ACTIONS
    
    @IBAction func btnLeftPressed(_ sender: UIButton) {
        
        let top_vc = UIApplication.topViewController()
        
        if self.didButtonLeftPressedBlock != nil {
            self.didButtonLeftPressedBlock()
        } else if let vc = top_vc {
            vc.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnRightPressed(_ sender: UIButton) {
        
        if self.didButtonRightPressedBlock != nil {
            self.didButtonRightPressedBlock()
        } else if let top_vc = UIApplication.topViewController() {
            top_vc.navigateTo(.notification_vc)
        }
    }
    
    @IBAction func didPressedQRCodeButton(_ sender: UIButton) {
        self.openScanner()
    }
}
