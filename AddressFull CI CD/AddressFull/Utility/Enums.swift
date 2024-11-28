//
//  Enums.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import Foundation
import UIKit


enum SettingsOptions : String {
    case my_account = "my_account"
    case app_lock = "app_lock"
    case notification = "notification"
    case data_protection_policy = "data_protection_policy"
    case help = "help"
    case security_questions = "security_questions"
    case blocked_organizations = "blocked_organizations"
    case delete_all_trsuted_organization = "delete_all_trsuted_organization"
    case delete_my_account = "delete_my_account"
    case logout = "logout"
}

enum SettingDeleteType {
    case trusted_organization
    case my_profile
}

enum PushNotificationType : Int {
    case delete_organization = 0
    case delete_account = 1
    case auto_sync = 2
    case request = 11
}

/// This enum is being used to retrive storyboard to redirect to particular screen
enum Storyboard : String {
    case splash = "Splash"
    case onboarding = "Onboarding"
    case authentication = "Authentication"
    case main = "Main"
    case home = "Home"
    case organization = "Organization"
    case settings = "Settings"
    case profile = "Profile"
    case scanner = "Scanner"
    case documentViewer = "DocumentViewer"
    case notification = "Notification"
    case popup = "Popup"
}


/// This enum is being used to get controllers for the app
enum ViewControllers {
   
    case tab_bar
    case splash_vc
    case onboarding_vc(scroll_to_at: Int)
    case signup_vc(is_for_login: Bool)
    case gdpr_compliance_vc(is_from_login: Bool,is_for_popia: Bool = false)
    case signup_otp_vc(country_code: String,country_iso_code: String, mobile_number: String)
    case login_with_security_question_vc(is_from_splash_screen: Bool,
                                         two_step_verification_question_answer_list: [TwoStepVerificationQuestionAnswerModel])
    case temporary_lock_vc
    case home_vc
    case profile_vc(is_from_login: Bool)
    case top_trusted_organization_vc
    case activity_vc
    case setting_vc
    case notification_vc
    case scanner_vc
    case request_vc
    case shared_data_vc
    case organization_profile(id: String,is_came_from_scanner: Bool = false)
    case organization_more_option_vc(organization_model: OrganizationListModel?, is_from_notification: Bool, button_titles: [String], block_completion: (() -> Void)?)
    case block_with_reason_vc(organization_model: OrganizationListModel?, block_completion: (() -> Void)?)
    case view_shared_data_vc(organization_model: OrganizationListModel?)
    case two_fector_vc
    case add_two_step_question_vc
    case help_vc(is_for_data_protection_policy: Bool)
    case app_lock_vc(is_for_notification: Bool)
    case delete_confirmation_vc
    case block_vc
    case data_subject_access_request_vc
    case document_viewer_vc(pdf_url: String)
    case alert_vc
    case web_view_vc(title: String,web_view_url: String)
    
    var controller: UIViewController {
        
        switch self {
           
        case .tab_bar:
            return TabBarController()
        case .splash_vc:
            return SplashVC()
        case .onboarding_vc:
            return OnboardingVC()
        case .signup_vc:
            if #available(iOS 16.0, *) {
                return SignUpVC()
            } else {
                return SplashVC()
            }
        case .gdpr_compliance_vc:
            return GDPRCompliancePopupViewVC()
        case .signup_otp_vc:
            return SignUpOTPVC()
        case .login_with_security_question_vc:
            return LoginWithSecurityQuestionVC()
        case .temporary_lock_vc:
            return TemporaryLockVC()
        case .home_vc:
            return HomeVC()
        case .profile_vc:
            return ProfileVC()
        case .top_trusted_organization_vc:
            return TopTrustedOrganisationVC()
        case .activity_vc:
            return ActivityLogsVC()
        case .setting_vc:
            return SettingVC()
        case .notification_vc:
            return NotificationsVC()
        case .scanner_vc:
            return ScannerVC()
        case .request_vc:
            return RequestVC()
        case .shared_data_vc:
            return SharedDataVC()
        case .organization_profile:
            return OrganizationProfileVC()
        case .organization_more_option_vc:
            return OrganizationMoreOptionsVC()
        case .block_with_reason_vc:
            return BlockWithReasonVC()
        case .view_shared_data_vc:
            return ViewSharedDataVC()
        case .two_fector_vc:
            return TwoFectorVC()
        case .add_two_step_question_vc:
            return AddTwoStepVerificationQueAnsVC()
        case .help_vc:
            return HelpVC()
        case .app_lock_vc:
            return AppLockVC()
        case .delete_confirmation_vc:
            return DeleteConfirmationSuccessVC()
        case .block_vc:
            return BlockVC()
        case .data_subject_access_request_vc:
            return DataSubjectAccessRequestVC()
        case .document_viewer_vc:
            return DocumentViewerVC()
        case .alert_vc:
            return AlertVC()
        case .web_view_vc(title: let title, web_view_url: let web_view_url):
            return WebViewVC()
        }
    }
    
    
    var identifier: String {
        return String(describing: type(of: self.controller)).components(separatedBy: ".").last ?? ""
    }
}
