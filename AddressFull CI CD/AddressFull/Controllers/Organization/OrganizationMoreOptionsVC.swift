//
//  OrganizationMoreOptionsVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit
import SDWebImage

class OrganizationMoreOptionsVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var button_titles : [String] = []
    var organization_model : OrganizationListModel?
    var organization_profile_view_model = OrganizationProfileViewModel()
    var notification_view_model = NotificationViewModel()
    var delete_completion : ((String) -> Void)?
    var block_completion : (() -> Void)?
    var is_from_notification = false
    
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var btn_close: BaseBoldButton!
    @IBOutlet weak var img_view_organization_profile: UIImageView!
    @IBOutlet weak var lbl_organization_title: AFLabelBold!
    @IBOutlet weak var btn_delete_organization: BaseBoldButton!
    @IBOutlet weak var btn_block_organization: BaseBoldButton!
    @IBOutlet weak var btn_shared_data_report: BaseBoldButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.img_view_organization_profile.makeRounded()
        self.localTextSetup()
        self.btn_close.setStyle(bg_color: .clear)
        
        self.btn_shared_data_report.setStyle(bg_color: AppColor.primary_green().withAlphaComponent(0.15),title_color: AppColor.primary_green())
        self.btn_delete_organization.setStyle(bg_color: AppColor.primary_red().withAlphaComponent(0.15),title_color: AppColor.primary_red())
        self.btn_block_organization.setStyle(bg_color: AppColor.primary_red().withAlphaComponent(0.15),title_color: AppColor.primary_red())
    }
    
    func localTextSetup() {
        
        if button_titles.count > 0 {
            self.btn_shared_data_report.setTitle(self.button_titles[0], for: .normal)
            self.btn_delete_organization.setTitle(self.button_titles[1], for: .normal)
            self.btn_block_organization.setTitle(self.button_titles[2], for: .normal)
        }
        
        self.lbl_organization_title.text = self.organization_model?.organization_name
        
        if let image_url = self.organization_model?.organization_profile_image, let url = URL(string: image_url) {
            
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            
            self.img_view_organization_profile.sd_imageIndicator = customIndicator
            self.img_view_organization_profile.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_view_organization_profile.image = UIImage(named: AssetsImage.placeholder) ?? UIImage()
        }
        
    }
    
    // MARK: - API CALL
    
    func deleteMyTrustedOrganization(view_for_progress_indicator: UIView) {
        self.organization_profile_view_model.deleteMyTrustedOrganizationApiCall(
            id: self.organization_model?.organizationId ?? "",
            view_for_progress_indicator: view_for_progress_indicator)
        { is_success, model in
           
            if is_success {
                
                if let delete_completion = self.delete_completion {
                    delete_completion(model?.message ?? "")
                }
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnClosePressed(_ sender: BaseBoldButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnDeleteOrganizationPressed(_ sender: BaseBoldButton) {
        if !self.is_from_notification {
            self.delete(type: .trusted_organization,
                        popupImage: self.img_view_organization_profile.image ?? UIImage(),
                        popupTitle: LocalText.Settings().remove_my_trusted_organization_confirmation_popup_title(),
                        popupButtonTitle: LocalText.Settings().delete_all_organizations(),
                        confirmationPopupImage: self.img_view_organization_profile.image ?? UIImage(),
                        confirmationPopupTitle: LocalText.Settings().remove_my_trusted_organization_confirmation_popup_title(),
                        firstOptionContent: LocalText.Settings().remove_my_trusted_organization_confirmation_popup_first_option(),
                        confirmationButtonTitle: LocalText.SignUpOtp().submit(),
                        submitButtomPrefixImage: AssetsImage.delete,
                        successPopupImage: self.img_view_organization_profile.image ?? UIImage(),
                        successPopupTitle: LocalText.Settings().my_trusted_organization_is_deleted(),
                        successButtonTitle: LocalText.Settings().okay()
            )
        }
    }
    
    fileprivate func delete(type: SettingDeleteType, popupImage: UIImage, popupTitle: String, popupButtonTitle: String, confirmationPopupImage: UIImage, confirmationPopupTitle: String, firstOptionContent: String? = nil, secondOptionContent: String? = nil, confirmationButtonTitle: String, submitButtomPrefixImage: String? = nil, successPopupImage: UIImage, successPopupTitle: String, successButtonTitle: String) {
        
        
        let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.setup(
            image: confirmationPopupImage,
            title: confirmationPopupTitle,
            firstOptionContent: firstOptionContent,
            secondOptionContent: secondOptionContent,
            submitButtonTitle: confirmationButtonTitle)
        
        vc.did_submit_button_pressed_block = { () in
            
            self.delete_completion = { message in
                vc.dismiss(animated: true) {
                    let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
                    vc.modalPresentationStyle = .overCurrentContext
                    
                    vc.setup(
                        image: successPopupImage,
                        title: message,
                        submitButtonTitle: successButtonTitle,
                        with_close_button: false)
                    
                    vc.did_submit_button_pressed_block = { () in
                        vc.dismiss(animated: true)
                        
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil, userInfo: nil)
                            NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil, userInfo: nil)
                        }
                    }
                    self.present(vc, animated: true)
                }
            }
            self.deleteMyTrustedOrganization(view_for_progress_indicator: vc.view)
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnBlockOrganizationPressed(_ sender: BaseBoldButton) {
        if !self.is_from_notification {
            self.navigateTo(.block_with_reason_vc(organization_model: self.organization_model,
                                                  block_completion: {
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        if let block_completion = self.block_completion {
                            block_completion()
                        }
                    }
                }
            }))
        }
    }
    
    @IBAction func btnSharedDataReportPressed(_ sender: BaseBoldButton) {
        if !self.is_from_notification {
            self.navigateTo(.view_shared_data_vc(organization_model: self.organization_model))
        }
    }
}
