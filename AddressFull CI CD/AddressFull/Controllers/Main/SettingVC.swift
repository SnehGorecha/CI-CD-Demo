//
//  SettingVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class SettingVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let settings_options_list = [
        SettingsOptions.app_lock.rawValue,
//        SettingsOptions.notification.rawValue,
        SettingsOptions.data_protection_policy.rawValue,
        SettingsOptions.help.rawValue,
        //        SettingsOptions.security_questions.rawValue,
        SettingsOptions.blocked_organizations.rawValue,
        SettingsOptions.delete_all_trsuted_organization.rawValue,
        SettingsOptions.delete_my_account.rawValue,
        SettingsOptions.logout.rawValue
    ]
    
    let settings_icon_list = [
        AssetsImage.app_lock,
//        AssetsImage.notification_round,
        AssetsImage.gdpr_settings,
        AssetsImage.help_filled,
        //        AssetsImage.security_questions,
        AssetsImage.block,
        AssetsImage.delete,
        AssetsImage.delete_my_account,
        AssetsImage.logout
    ]
    let settings_view_model = SettingsViewModel()
    
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_settings_list: SingleLabelTblView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Settings().setting(),
                                               isWithBackOption: false,{
            self.navigateTo(.profile_vc(is_from_login: false))
        })
    }
    
    
    override func refreshViaDataSyncNotification(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.navigation_bar.navigationBarSetup(title: LocalText.Settings().setting(),
                                                   isWithBackOption: false,{
                self.navigateTo(.profile_vc(is_from_login: false))
            })
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.tblViewSettingSetup()
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewSettingSetup() {
        
        self.tbl_view_settings_list.name_list = self.settings_options_list
        self.tbl_view_settings_list.icon_list = self.settings_icon_list
        self.tbl_view_settings_list.bg_color = .white
        self.tbl_view_settings_list.reloadData()
        
        self.tbl_view_settings_list.row_height = UtilityManager().getPropotionalHeight(baseHeight: 812, height: 60)
        self.tbl_view_settings_list.did_option_selected_block = { (option, selected_index) in
            
            if option == SettingsOptions.app_lock.rawValue {
                self.navigateTo(.app_lock_vc(is_for_notification: false))
            }
            
            else if option == SettingsOptions.notification.rawValue {
                self.navigateTo(.app_lock_vc(is_for_notification: true))
            }
            
            else if option == SettingsOptions.data_protection_policy.rawValue {
                self.navigateTo(.help_vc(is_for_data_protection_policy: true))
            }
            
            else if option == SettingsOptions.help.rawValue {
                self.navigateTo(.help_vc(is_for_data_protection_policy: false))
            }
            
            else if option == SettingsOptions.security_questions.rawValue {
                self.navigateTo(.two_fector_vc)
            }
            
            else if option == SettingsOptions.blocked_organizations.rawValue {
                self.navigateTo(.block_vc)
            }
            
            else if option == SettingsOptions.delete_all_trsuted_organization.rawValue {
                self.delete(type: .trusted_organization,
                            option: option,
                            popupImage: UIImage(named: AssetsImage.delete_icon_big) ?? UIImage(),
                            popupTitle: LocalText.Settings().remove_all_trusted_organization_popup_title(),
                            popupButtonTitle: LocalText.Settings().delete_all_organizations(),
                            confirmationPopupImage: UIImage(named: AssetsImage.delete_icon_big) ?? UIImage(),
                            confirmationPopupTitle: LocalText.Settings().remove_all_trusted_organization_confirmation_popup_title(), secondConfirmationPopupTitle: "",
                            firstOptionContent: LocalText.Settings().remove_all_trusted_organization_confirmation_popup_first_option(),
                            secondOptionContent: nil,
                            confirmationButtonTitle: LocalText.AlertButton().yes_i_want_to_delete_all_of_my_trusted_organizations(),
                            submitButtomPrefixImage: AssetsImage.delete,
                            successPopupImage: UIImage(named: AssetsImage.big_checkmark_checked) ?? UIImage(),
                            successPopupTitle: LocalText.Settings().trusted_organization_are_deleted(),
                            successButtonTitle: LocalText.Settings().okay()
                )
            }
            else if option == SettingsOptions.delete_my_account.rawValue {
                
                let data = UserDetailsModel.shared.image
                let image = UIImage(data: data)
                
                self.delete(type: .my_profile,
                            option: option,
                            popupImage: image ?? UIImage(named: AssetsImage.profile_placeholder) ?? UIImage(),
                            popupTitle: LocalText.Settings().delete_my_account(),
                            popupButtonTitle: LocalText.Settings().delete(),
                            confirmationPopupImage: image ?? UIImage(named: AssetsImage.profile_placeholder) ?? UIImage(),
                            confirmationPopupTitle: LocalText.Settings().remove_my_profile_confirmation_popup_title(),
                            secondConfirmationPopupTitle: LocalText.Settings().remove_my_profile_confirmation_popup_second_title(),
                            firstOptionContent: LocalText.Settings().remove_my_profile_confirmation_popup_first_option(),
                            secondOptionContent: LocalText.Settings().remove_my_profile_confirmation_popup_second_option(),
                            thirdOptionContent: LocalText.Settings().remove_my_profile_confirmation_popup_third_option(),
                            confirmationButtonTitle: LocalText.AlertButton().yes_permanently_delete_my_account(),
                            submitButtomPrefixImage: AssetsImage.delete,
                            successPopupImage: UIImage(named: AssetsImage.big_checkmark_checked) ?? UIImage(),
                            successPopupTitle: LocalText.Settings().my_profile_deleted(),
                            successButtonTitle: LocalText.Settings().okay()
                )
            } else if option == SettingsOptions.logout.rawValue {
                
                self.showPopupAlert(title: Message.are_you_sure_you_want_to_log_out(),
                                    message: nil,
                                    leftTitle: LocalText.AlertButton().yes(),
                                    rightTitle: LocalText.AlertButton().no(),
                                    didPressedLeftButton: {
                    self.logoutUser(message: Message.logout_successfully())
                },
                                    didPressedRightButton: nil)
            }
        }
    }
    
    fileprivate func delete(type: SettingDeleteType, 
                            option: String,
                            popupImage: UIImage,
                            popupTitle: String,
                            popupButtonTitle: String,
                            confirmationPopupImage: UIImage,
                            confirmationPopupTitle: String,
                            secondConfirmationPopupTitle: String,
                            firstOptionContent: String? = nil,
                            secondOptionContent: String? = nil,
                            thirdOptionContent: String? = nil,
                            confirmationButtonTitle: String,
                            submitButtomPrefixImage: String? = nil,
                            successPopupImage: UIImage,
                            successPopupTitle: String,
                            successButtonTitle: String) {
        
        
        let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
        vc.modalPresentationStyle = .overFullScreen
        
        vc.setup(
            image: type == .my_profile ? confirmationPopupImage : popupImage,
            title: type == .my_profile ? confirmationPopupTitle : popupTitle,
            firstOptionContent: type == .my_profile ? firstOptionContent : nil,
            secondOptionContent: type == .my_profile ? secondOptionContent : nil,
            submitButtonTitle: popupButtonTitle,
            submitButtomPrefixImage: submitButtomPrefixImage)
        
        
        vc.did_submit_button_pressed_block = { () in
            vc.dismiss(animated: true) {
                
                let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
                vc.modalPresentationStyle = .overFullScreen
                
                vc.setup(
                    image: type == .my_profile ? popupImage : confirmationPopupImage,
                    title: type == .my_profile ? secondConfirmationPopupTitle : confirmationPopupTitle,
                    firstOptionContent: type == .my_profile ? nil : firstOptionContent,
                    secondOptionContent: type == .my_profile ? nil : secondOptionContent,
                    thirdOptionContent: type == .my_profile ? thirdOptionContent : nil,
                    submitButtonTitle: confirmationButtonTitle,
                    noButtonTitle: type == .my_profile ? LocalText.AlertButton().no() : "",
                    with_no_button: false,
                    with_exclamation_mark: type == .my_profile)
                
                
                vc.did_submit_button_pressed_block = { () in
                    
                    self.delete(type, view_for_progress_indicator: vc.view) { message in
                        
                        vc.dismiss(animated: true) {
                            
                            let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
                            vc.modalPresentationStyle = .overFullScreen
                            
                            vc.setup(
                                image: successPopupImage,
                                title: message,
                                submitButtonTitle: successButtonTitle,
                                with_close_button: false)
                           
                            
                            vc.did_submit_button_pressed_block = { () in
                                
                                vc.dismiss(animated: true) {
                                    
                                    if type == .trusted_organization {
                                        DispatchQueue.main.async {
                                            self.navigation_bar.navigationBarSetup(title: LocalText.Settings().setting(),isWithBackOption: false,{
                                                self.navigateTo(.profile_vc(is_from_login: false))
                                            })
                                        }
                                    }
                                }
                            }
                            
                            self.present(vc, animated: true)
                        }
                    }
                }
                self.present(vc, animated: true)
            }
        }
        self.present(vc, animated: true)
    }
    
    
    // MARK: - API CALL
    
    func delete(_ type: SettingDeleteType, view_for_progress_indicator: UIView,completion: (@escaping(String) -> Void)) {
        
        self.settings_view_model.deleteApiCall(type, view_for_progress_indicator: view_for_progress_indicator)
        { is_success, model in
            
            if is_success {
                
                if type == .my_profile {

                    self.deleteUserAccount(message: model?.message)
                    
                } else {
                    GlobalVariables.shared.sync_data_completed = false
                    
                    UserDefaults.standard.setValue(GlobalVariables.shared.sync_data_completed, forKey: UserDefaultsKey.sync_data_completed)
                }
                
                completion(model?.message ?? "")
            }
        }
    }
}
