//
//  UIViewControllerExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


extension UIViewController {
    
    /// To show UIAlertController with customisation, like, UITextField, UIAlertControllerStyle and there are parameter mentioend as well. This function also willl work with iPad as well.
    func popupAlert(title: String?,
                    message: String?,
                    alertStyle: UIAlertController.Style = .alert,
                    withTextField: Bool = false,
                    actionTitles:[String?],
                    completionHandler: ((_ index: Int, _ title: String, _ textFieldText: String?) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : alertStyle)
        
        if withTextField {
            alert.addTextField() { newTextField in
                newTextField.placeholder = ""
            }
        }
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
        }
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: title?.lowercased() == "cancel" ? .cancel : .default) { action in
                
                var text: String?
                if let textFields = alert.textFields, let tf = textFields.first, let result = tf.text {
                    text = result
                }
                
                completionHandler?(index, title ?? "", title?.lowercased() == "ok" ? text : nil)
            }
            
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showPopupAlert(title: String?,
                        message: String?,
                        leftTitle: String?,
                        rightTitle: String?,
                        image_icon: String? = nil,
                        is_img_hidden: Bool = true,
                        is_for_version_update: Bool = false,
                        close_button_hidden: Bool = false,
                        didPressedLeftButton : (() -> Void)?,
                        didPressedRightButton : (() -> Void)?) {
        
        DispatchQueue.main.async {
            
            let vc = self.getController(from: .popup, controller: .alert_vc) as! AlertVC
            vc.modalPresentationStyle = .overFullScreen
            
            vc.alert_message = message ?? ""
            vc.alert_title = title ?? ""
            vc.left_button_title = leftTitle ?? ""
            vc.right_button_title = rightTitle ?? ""
            vc.close_button_hidden = close_button_hidden
            vc.image_icon = image_icon
            vc.is_img_hidden = is_img_hidden
            vc.is_for_version_update = is_for_version_update
            
            vc.didButtonLeftPressedBlock = {
                if let didPressedLeftButton = didPressedLeftButton {
                    didPressedLeftButton()
                }
            }
            
            vc.didButtonRightPressedBlock = {
                if let didPressedRightButton = didPressedRightButton {
                    didPressedRightButton()
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
            }
            
            self.present(vc, animated: true)
        }
    }
    
    
    func setAsRootViewController() {
        let navVC = UINavigationController(rootViewController: self)
        
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}



// MARK: - EXTENSION FOR NAVIGATIONS

extension UIViewController {
    
    /// Use this function to get controller from Storyboard enum
    func getController(from storyboard: Storyboard,controller: ViewControllers) -> UIViewController {
        
        switch storyboard {
            
        case .splash:
            return (UIStoryboard().splash().instantiateViewController(withIdentifier: controller.identifier))
        case .onboarding:
            return (UIStoryboard().onboarding().instantiateViewController(withIdentifier: controller.identifier))
        case .authentication:
            return (UIStoryboard().authentication().instantiateViewController(withIdentifier: controller.identifier))
        case .main:
            return (UIStoryboard().main().instantiateViewController(withIdentifier: controller.identifier))
        case .home:
            return (UIStoryboard().home().instantiateViewController(withIdentifier: controller.identifier))
        case .organization:
            return (UIStoryboard().organization().instantiateViewController(withIdentifier: controller.identifier))
        case .settings:
            return (UIStoryboard().settings().instantiateViewController(withIdentifier: controller.identifier))
        case .profile:
            return (UIStoryboard().profile().instantiateViewController(withIdentifier: controller.identifier))
        case .scanner:
            return (UIStoryboard().scanner().instantiateViewController(withIdentifier: controller.identifier))
        case .documentViewer:
            return (UIStoryboard().documentViewer().instantiateViewController(withIdentifier: controller.identifier))
        case .notification:
            return (UIStoryboard().notification().instantiateViewController(withIdentifier: controller.identifier))
        case .popup:
            return (UIStoryboard().popup().instantiateViewController(withIdentifier: controller.identifier))
        }
    }
    
    
    /// Use this function navigate to controller
    func navigateTo(_ controller : ViewControllers) {
        var vc : UIViewController?
        
        switch controller {
            
        case .tab_bar:
            vc = self.getController(from: .main, controller: controller) as! TabBarController
            
        case .splash_vc:
            vc = self.getController(from: .splash, controller: controller) as! SplashVC
            
        case .onboarding_vc(scroll_to_at : let scroll_to_at):
            vc = self.getController(from: .onboarding, controller: controller) as! OnboardingVC
            (vc as! OnboardingVC).scroll_to_at = scroll_to_at
            
        case .signup_vc(is_for_login: let is_for_login):
            
            if #available(iOS 16.0, *) {
                vc = self.getController(from: .authentication, controller: controller) as! SignUpVC
                (vc as! SignUpVC).is_for_login = is_for_login
                
            } else {
                // Fallback on earlier versions
            }
            
        case .gdpr_compliance_vc(is_from_login: let is_from_login,is_for_popia: let is_for_popia):
            vc = self.getController(from: .authentication, controller: controller) as! GDPRCompliancePopupViewVC
            (vc as! GDPRCompliancePopupViewVC).is_from_login = is_from_login
            (vc as! GDPRCompliancePopupViewVC).is_for_popia = is_for_popia
            (vc as! GDPRCompliancePopupViewVC).hidesBottomBarWhenPushed = true
            
        case .signup_otp_vc(country_code: let country_code,
                            country_iso_code: let country_iso_code,
                            mobile_number: let mobile_number):
            vc = self.getController(from: .authentication, controller: controller) as! SignUpOTPVC
            (vc as! SignUpOTPVC).country_code = country_code
            (vc as! SignUpOTPVC).country_iso_code = country_iso_code
            (vc as! SignUpOTPVC).mobile_number = mobile_number
            
        case .login_with_security_question_vc(is_from_splash_screen: let is_from_splash_screen,
                                              two_step_verification_question_answer_list: let two_step_verification_question_answer_list):
            
            vc = self.getController(from: .authentication, controller: controller) as! LoginWithSecurityQuestionVC
            (vc as! LoginWithSecurityQuestionVC).is_from_splash_screen = is_from_splash_screen
            (vc as! LoginWithSecurityQuestionVC).two_step_verification_question_answer_list = two_step_verification_question_answer_list
            (vc as! LoginWithSecurityQuestionVC).hidesBottomBarWhenPushed = true
            
        case .temporary_lock_vc:
            vc = self.getController(from: .authentication, controller: controller) as! TemporaryLockVC
            (vc as! TemporaryLockVC).hidesBottomBarWhenPushed = true
            
        case .home_vc:
            vc = self.getController(from: .main, controller: controller) as! HomeVC
            
        case .profile_vc(is_from_login: let is_from_login):
            vc = self.getController(from: .profile, controller: controller) as! ProfileVC
            (vc as! ProfileVC).is_from_login = is_from_login
            (vc as! ProfileVC).hidesBottomBarWhenPushed = true
            
        case .top_trusted_organization_vc:
            vc = self.getController(from: .main, controller: controller) as! TopTrustedOrganisationVC
            
        case .activity_vc:
            vc = self.getController(from: .main, controller: controller) as! ActivityLogsVC
            
        case .setting_vc:
            vc = self.getController(from: .main, controller: controller) as! SettingVC
            
        case .notification_vc:
            vc = self.getController(from: .notification, controller: controller) as! NotificationsVC
            (vc as! NotificationsVC).hidesBottomBarWhenPushed = true
            
        case .scanner_vc:
            vc = self.getController(from: .scanner, controller: controller) as! ScannerVC
            
        case .request_vc:
            vc = self.getController(from: .home, controller: controller) as! RequestVC
            (vc as! RequestVC).hidesBottomBarWhenPushed = true
            
        case .shared_data_vc:
            vc = self.getController(from: .home, controller: controller) as! SharedDataVC
            (vc as! SharedDataVC).hidesBottomBarWhenPushed = true
            
        case .organization_profile(id: let id,is_came_from_scanner: let is_came_from_scanner):
            vc = self.getController(from: .organization, controller: controller) as! OrganizationProfileVC
            (vc as! OrganizationProfileVC).id = id
            (vc as! OrganizationProfileVC).is_came_from_scanner = is_came_from_scanner
            (vc as! OrganizationProfileVC).hidesBottomBarWhenPushed = true
            
        case .organization_more_option_vc(organization_model: let organization_model,
                                          is_from_notification: let is_from_notification,
                                          button_titles: let button_titles,
                                          block_completion: let block_completion):
            
            vc = self.getController(from: .organization, controller: controller) as! OrganizationMoreOptionsVC
            (vc as! OrganizationMoreOptionsVC).organization_model = organization_model
            (vc as! OrganizationMoreOptionsVC).button_titles = button_titles
            (vc as! OrganizationMoreOptionsVC).is_from_notification = is_from_notification
            (vc as! OrganizationMoreOptionsVC).block_completion = block_completion
            (vc as! OrganizationMoreOptionsVC).modalPresentationStyle = .overFullScreen
            
        case .block_with_reason_vc(organization_model: let organization_model, block_completion: let block_completion):
            vc = self.getController(from: .organization, controller: controller) as! BlockWithReasonVC
            (vc as! BlockWithReasonVC).organization_model = organization_model
            (vc as! BlockWithReasonVC).modalPresentationStyle = .overFullScreen
            (vc as! BlockWithReasonVC).block_completion = block_completion
            
        case .view_shared_data_vc(organization_model: let organization_model):
            vc = self.getController(from: .organization, controller: controller) as! ViewSharedDataVC
            (vc as! ViewSharedDataVC).organization_model = organization_model
            (vc as! ViewSharedDataVC).modalPresentationStyle = .overFullScreen
            
        case .two_fector_vc:
            vc = self.getController(from: .settings, controller: controller) as! TwoFectorVC
            (vc as! TwoFectorVC).hidesBottomBarWhenPushed = true
            
        case .add_two_step_question_vc:
            vc = self.getController(from: .settings, controller: controller) as! AddTwoStepVerificationQueAnsVC
            (vc as! AddTwoStepVerificationQueAnsVC).hidesBottomBarWhenPushed = true
            
        case .help_vc(is_for_data_protection_policy: let is_for_data_protection_policy):
            vc = self.getController(from: .settings, controller: controller) as! HelpVC
            (vc as! HelpVC).is_for_data_protection_policy = is_for_data_protection_policy
            (vc as! HelpVC).hidesBottomBarWhenPushed = true
            
        case .app_lock_vc(is_for_notification: let is_for_notification):
            vc = self.getController(from: .settings, controller: controller) as! AppLockVC
            (vc as! AppLockVC).is_for_notification = is_for_notification
            (vc as! AppLockVC).hidesBottomBarWhenPushed = true
            
        case .delete_confirmation_vc:
            vc = self.getController(from: .settings, controller: controller) as! DeleteConfirmationSuccessVC
            
        case .block_vc:
            vc = self.getController(from: .settings, controller: controller) as! BlockVC
            (vc as! BlockVC).hidesBottomBarWhenPushed = true
            
        case .data_subject_access_request_vc:
            vc = self.getController(from: .main, controller: controller) as! DataSubjectAccessRequestVC
            
        case .document_viewer_vc(pdf_url: let pdf_url):
            vc = self.getController(from: .documentViewer, controller: controller) as! DocumentViewerVC
            (vc as! DocumentViewerVC).pdf_url = pdf_url
            (vc as! DocumentViewerVC).hidesBottomBarWhenPushed = true
            
        case .alert_vc:
            vc = self.getController(from: .popup, controller: controller) as! AlertVC
            (vc as! AlertVC).modalPresentationStyle = .overFullScreen
            
        case .web_view_vc(title: let title, web_view_url: let web_view_url):
            vc = self.getController(from: .settings, controller: controller) as! WebViewVC
            (vc as! WebViewVC).web_view_title = title
            (vc as! WebViewVC).web_view_url = web_view_url
            (vc as! WebViewVC).hidesBottomBarWhenPushed = true
        }
        
        if let vc = vc {
            if (vc is BlockWithReasonVC) || (vc is ViewSharedDataVC) || (vc is OrganizationMoreOptionsVC) || (vc is AlertVC)  {
                self.presentController(controller: vc)
            } else {
                self.pushController(controller: vc)
            }
        }
    }
    
    fileprivate func pushController(controller: UIViewController) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    fileprivate func presentController(controller: UIViewController) {
        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}
