//
//  AlertVC.swift
//  AddressFull
//
//  Created by Sneh on 12/03/24.
//

import UIKit

class AlertVC: BaseViewController {

    // MARK: - OBJECTS & OUTLETS
    
    var didButtonLeftPressedBlock : (() -> Void)!
    var didButtonRightPressedBlock : (() -> Void)!
    var left_button_title = ""
    var right_button_title = ""
    var alert_title = ""
    var alert_message = ""
    var close_button_hidden = false
    var is_img_hidden = true
    var image_icon : String? = nil
    var is_for_version_update : Bool = false
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var view_image: UIView!
    @IBOutlet weak var view_close_button: UIView!
    @IBOutlet weak var view_right_button: UIView!
    @IBOutlet weak var view_left_button: UIView!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var btn_right: BaseBoldButton!
    @IBOutlet weak var btn_left: BaseBoldButton!
    @IBOutlet weak var view_message: UIView!
    @IBOutlet weak var lbl_message: AFLabelRegular!
    @IBOutlet weak var view_title: UIView!
    @IBOutlet weak var lbl_title: AFLabelBold!
    @IBOutlet weak var btn_close: UIButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupLocalText()
        self.manageVisibilities()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.btn_close.setStyle(bg_color: .clear)
        
        self.btn_left.setStyle(cornerRadius: 14,
                               bg_color: .clear,
                               title_color: AppColor.primary_red(),
                               border_color: AppColor.primary_red())
        
        self.btn_right.setStyle(cornerRadius: 14,
                                bg_color: self.is_for_version_update ? AppColor.primary_green() : AppColor.primary_green().withAlphaComponent(0.15),
                                title_color: self.is_for_version_update ? .white : AppColor.primary_green(),
                                border_color: .clear)
        
        let data = UserDetailsModel.shared.image
        let image = UIImage(data: data)
        
        if let image_icon = self.image_icon {
            self.img_profile.image = UIImage(named: image_icon)
        } else {
            self.img_profile.image = image ?? UIImage(named: AssetsImage.profile_placeholder)
        }
        
        self.img_profile.makeRounded()
        
        self.view_image.isHidden = self.is_img_hidden
    }
    
    func manageVisibilities() {
        self.view_title.isHidden = self.alert_title == ""
        self.view_message.isHidden = self.alert_message == ""
        self.view_left_button.isHidden = self.left_button_title == ""
        self.view_right_button.isHidden = self.right_button_title == ""
        self.btn_close.isHidden = self.close_button_hidden
    }
    
    func setupLocalText() {
        self.btn_left.setTitle(self.left_button_title, for: .normal)
        self.btn_right.setTitle(self.right_button_title, for: .normal)
        self.lbl_title.text = self.alert_title
        self.lbl_message.text = self.alert_message
    }
    
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnRightPressed(_ sender: BaseBoldButton) {
        if let didButtonRightPressedBlock = self.didButtonRightPressedBlock {
            didButtonRightPressedBlock()
        }
    }
    
    @IBAction func btnLeftPressed(_ sender: BaseBoldButton) {
        if let didButtonLeftPressedBlock = self.didButtonLeftPressedBlock {
            didButtonLeftPressedBlock()
        }
    }
    
    @IBAction func btnClosePressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}
