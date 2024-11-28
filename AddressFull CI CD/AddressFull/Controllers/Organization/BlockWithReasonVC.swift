//
//  BlockWithReasonVC.swift
//  AddressFull
//
//  Created by Sneh on 11/23/23.
//

import UIKit

class BlockWithReasonVC: UIViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var organization_model : OrganizationListModel?
    var block_completion : (() -> Void)?
    
    @IBOutlet weak var lbl_description: AFLabelRegular!
    @IBOutlet weak var txt_description: UITextView!
    @IBOutlet weak var lbl_title: AFLabelBold!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var lbl_placeholder: UILabel!
    @IBOutlet weak var btn_block: BaseBoldButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.btn_block.setStyle()
             
        self.txt_description.setupLayer(cornerRadius: 14)
        self.txt_description.backgroundColor = AppColor.light_gray()
        self.txt_description.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 10)
        self.txt_description.delegate = self
        
        self.lbl_placeholder.text = LocalText.ReportReason().write_here()
        
        self.localTextSetup()
    }
    
    func localTextSetup() {
        self.lbl_title.text = LocalText.BlockReason().block_reason_title()
        self.lbl_description.text = LocalText.BlockReason().block_reason_description()
        self.btn_block.setTitle(LocalText.BlockReason().block(), for: .normal)
    }
    
    
    // MARK: - API CALL
    
    func callBlockApi(reason: String) {
        BlockedOrganizationViewModel().blockUnblockOrganizationApiCall(organization_id: self.organization_model?.organizationId,
                                                                       block: true,
                                                                       reason: reason, view_for_progress_indicator: self.view)
        { is_success in
            if is_success {
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                
                if let block_completion = self.block_completion {
                    block_completion()
                }
                
                NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil)
                NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil)
            }
        }
    }
   
    // MARK: - BUTTON'S ACTIONS

    @IBAction func btnClosePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnBlockPressed(_ sender: BaseBoldButton) {
        let text = self.txt_description.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text != "" {
            self.callBlockApi(reason: text)
        } else {
            UtilityManager().showToast(message: ValidationMessage.please_provide_reason_for_block())
        }
    }
}


// MARK: - EXTENSION TEXTVIEW

extension BlockWithReasonVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        AutoLock.shared.startInactivityTimer()
        
        if self.txt_description.text.isEmpty || self.txt_description.text == "" {
            self.lbl_placeholder.isHidden = false
        } else {
            self.lbl_placeholder.isHidden = true
        }
    }
}
