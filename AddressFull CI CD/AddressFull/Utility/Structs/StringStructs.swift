//
//  StringStructs.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation


struct LocalText {
    
    struct SplashScreen {
        let address_full = { "address_full".localized() }
        let consent_based_information_sharing_application = { "consent_based_information_sharing_application".localized() }
    }
    
    struct Onboarding {
        let get_started = { "get_started".localized() }
        let next = { "next".localized() }
        let done = { "done".localized() }
        let onboarding_one_title = { "onboarding_one_title".localized() }
        let onboarding_two_title = { "onboarding_two_title".localized() }
        let onboarding_three_title = { "onboarding_three_title".localized() }
        let onboarding_four_title = { "onboarding_four_title".localized() }
        let onboarding_one_desc = { "onboarding_one_desc".localized() }
        let onboarding_two_desc = { "onboarding_two_desc".localized() }
        let onboarding_three_desc = { "onboarding_three_desc".localized() }
    }
    
    struct SignUpScreen {
        let sign_up = { "sign_up".localized() }
        let register_account = { "register_account".localized() }
        let select_mobile_number_and_continue = { "select_mobile_number_and_continue".localized() }
        let mobile_number = { "mobile_number".localized() }
        let mobile_numbers = { "mobile_numbers".localized() }
        let mobile_number_star = { "mobile_number*".localized() }
        let select_mobile_number = { "select_mobile_number".localized() }
        let agree_gdpr = { "agree_gdpr".localized() }
        let send_otp = { "send_otp".localized() }
    }
    
    struct LoginWithSecurityQuestion {
        let attempts_remaining = { "attempts_remaining".localized() }
    }
    
    struct TemporaryLock {
        let you_can_login_again_after = { "you_can_login_again_after".localized() }
        let app_is_temporary_locked = { "app_is_temporary_locked".localized() }
    }
    
    struct AlertButton {
        let ok = { "ok".localized() }
        let cancel = { "cancel".localized() }
        let yes = { "yes".localized() }
        let yes_permanently_delete_my_account = { "yes_permanently_delete_my_account".localized() }
        let yes_i_want_to_delete_all_of_my_trusted_organizations = { "yes_i_want_to_delete_all_of_my_trusted_organizations".localized() }
        let no = { "no".localized() }
        let settings = { "settings".localized() }
        let try_again = { "try_again".localized() }
    }
    
    struct GDPRCompliance {
        let agree = { "agree".localized() }
        let gdpr_content = { "gdpr_content".localized() }
        let gdpr_content_title_one = { "gdpr_content_title_one".localized() }
        let gdpr_content_title_two = { "gdpr_content_title_two".localized() }
        let gdpr_content_title_three = { "gdpr_content_title_three".localized() }
        let gdpr_content_title_four = { "gdpr_content_title_four".localized() }
        let gdpr_content_title_five = { "gdpr_content_title_five".localized() }
        let gdpr_content_title_six = { "gdpr_content_title_six".localized() }
        let gdpr_content_title_seven = { "gdpr_content_title_seven".localized() }
        let gdpr_content_title_eight = { "gdpr_content_title_eight".localized() }
        let gdpr_content_title_nine = { "gdpr_content_title_nine".localized() }
        let gdpr_content_title_ten = { "gdpr_content_title_ten".localized() }
        let gdpr_content_title_eleven = { "gdpr_content_title_eleven".localized() }
        let gdpr_terms_and_condition = { "gdpr_terms_and_condition".localized() }
    }
    
    struct POPIACompliance {
        let popia_content = { "popia_content".localized() }
        let popia_content_title_one = { "popia_content_title_one".localized() }
        let popia_content_title_two = { "popia_content_title_two".localized() }
        let popia_content_title_three = { "popia_content_title_three".localized() }
        let popia_content_title_four = { "popia_content_title_four".localized() }
        let popia_content_title_five = { "popia_content_title_five".localized() }
        let popia_content_title_six = { "popia_content_title_six".localized() }
        let popia_content_title_seven = { "popia_content_title_seven".localized() }
        let popia_content_title_eight = { "popia_content_title_eight".localized() }
        let popia_content_title_nine = { "popia_content_title_nine".localized() }
        let popia_content_title_ten = { "popia_content_title_ten".localized() }
        let popia_content_title_eleven = { "popia_content_title_eleven".localized() }
        let popia_terms_and_condition = { "popia_terms_and_condition".localized() }
    }
    
    struct SignUpOtp {
        let sms_verification = { "sms_verification".localized() }
        let please_check_your_sms = { "please_check_your_sms".localized() }
        let we_wanted_to_verify = { "we_wanted_to_verify".localized() }
        let code = { "code".localized() }
        let enter_otp_sent_on = { "enter_otp_sent_on".localized() }
        let resend_sms_verification_code = { "resend_sms_verification_code".localized() }
        let submit = { "submit".localized() }
        let verify = { "verify".localized() }
        let resend_in = { "resend_in".localized() }
    }
    
    struct MobileNumberSelect {
        let please_select_mobile_number = { "please_select_mobile_number".localized() }
    }
    
    struct BioMetricAuthentication {
        let identify_yourself = { "identify_yourself".localized() }
        let biometric_authentication = { "biometric_authentication".localized() }
        let login = { "login".localized() }
        let welcome_back = { "welcome_back!".localized() }
        let face_id = { "face_id".localized() }
        let touch_id = { "touch_id".localized() }
        let passcode = { "passcode".localized() }
        let biometryNotAvailable = { "biometryNotAvailable".localized() }
        let biometryLockout = { "biometryLockout".localized() }
        let biometryNotEnrolled = { "biometryNotEnrolled".localized() }
        let defaultMessage = { "defaultMessage".localized() }
        let touchIDLockout = { "touchIDLockout".localized() }
        let touchIDNotAvailable = { "touchIDNotAvailable".localized() }
        let touchIDNotEnrolled = { "touchIDNotEnrolled".localized() }
        let authenticationFailed = { "authenticationFailed".localized() }
        let appCancel = { "appCancel".localized() }
        let invalidContext = { "invalidContext".localized() }
        let notInteractive = { "notInteractive".localized() }
        let passcodeNotSet = { "passcodeNotSet".localized() }
        let systemCancel = { "systemCancel".localized() }
        let userCancel = { "userCancel".localized() }
        let userFallback = { "userFallback".localized() }
        let finger_print_scanner = { "finger_print_scanner".localized() }
        let app_is_locked = { "app_is_locked".localized() }
        let unlock = { "unlock".localized() }
    }
    
    struct Home {
        let home_screen = { "home_screen".localized() }
        let requests = { "requests".localized() }
        let new_requests = { "new_requests".localized() }
        let search_organization = { "search_organization".localized() }
        let its_time_to_start_connecting = { "its_time_to_start_connecting".localized() }
        let no_organization_found = { "no_organization_found".localized() }
        let view_requests = { "view_requests".localized() }
        let my_trusted_organizations = { "my_trusted_organizations".localized() }
        let top_organizations = { "top_organizations".localized() }
        let shared_data = { "shared_data".localized() }
        let my_shared_details = { "my_shared_details".localized() }
        let data_subject_access_request = { "data_subject_access_request".localized() }
        let shared_data_report = { "shared_data_report".localized() }
    }
    
    struct TrustedOrganization {
        let search_organization = { "search_organization".localized() }
        let trusted_organization = { "trusted_organization".localized() }
        let search = { "search".localized() }
        let top_trusted_organization = { "top_trusted_organization".localized() }
        let search_result = { "search_result".localized() }
    }
    
    struct OrganizationMoreOptions {
        let delete_organization = { "delete_organization".localized() }
        let block_organization = { "block_organization".localized() }
        let view_shared_data = { "view_shared_data".localized() }
    }
    
    struct Request {
        let requests = { "requests".localized() }
        let recent = { "recent".localized() }
        let previous = { "previous".localized() }
        let accept = { "accept".localized() }
        let reject = { "reject".localized() }
        let request_to_access_your_address = { "request_to_access_your_address".localized() }
        let request_to_access_mobile_number = { "request_to_access_mobile_number".localized() }
        let request_to_access_email = { "request_to_access_email".localized() }
        let start_date = { "start_date".localized() }
        let end_date = { "end_date".localized() }
        let filter = { "filter".localized() }
    }
    
    struct MyProfile {
        let my_profile = { "my_profile".localized() }
        let edit = { "edit".localized() }
        let email = { "email".localized() }
        let email_star = { "email*".localized() }
        let address = { "address".localized() }
        let address_star = { "address*".localized() }
        let social = { "social".localized() }
        let social_media = { "social_media".localized() }
        let add_more = { "add_more".localized() }
        let select_question = { "select_question".localized() }
        let question = { "question".localized() }
        let answer_here = { "answer_here".localized() }
        let save = { "save".localized() }
        let save_now = { "save_now".localized() }
        let what_city_were_you_born_in = { "what_city_were_you_born_in".localized() }
        let what_is_the_name_of_your_first_pet = { "what_is_the_name_of_your_first_pet".localized() }
        let what_is_your_favorite_book_or_movie = { "what_is_your_favorite_book_or_movie".localized() }
        let what_is_your_nick_name = { "what_is_your_nick_name".localized() }
        let what_is_your_favorite_food = { "what_is_your_favorite_food".localized() }
        let answer_the_security_question = { "answer_the_security_question".localized() }
    }
    
    struct Profile {
        let complete_your_profile = { "complete_your_profile".localized() }
        let name = { "name".localized() }
        let first_name_star = { "first_name*".localized() }
        let first_name = { "first_name".localized() }
        let last_name_star = { "last_name*".localized() }
        let last_name = { "last_name".localized() }
        let security_questions = { "security_questions*".localized() }
        let back = { "back".localized() }
    }
    
    struct PersonalDetails {
        let primary = { "primary".localized() }
        let home = { "home".localized() }
        let work = { "work".localized() }
        let secondary = { "secondary".localized() }
        let mobile_number = { "mobile_number".localized() }
        let email = { "email".localized() }
        let emails = { "emails".localized() }
        let address = { "address".localized() }
        let addresses = { "addresses".localized() }
        let linkedin = { "linkedin".localized() }
        let twitter = { "twitter".localized() }
        let no_linkedin_url = { "no_linkedin_url".localized() }
        let no_twitter_url = { "no_twitter_url".localized() }
    }
    
    struct Email {
        let social = { "social".localized() }
        let promotions = { "promotions".localized() }
        let updates = { "updates".localized() }
    }
    
    struct Address {
        let work = { "work".localized() }
        let shipping = { "shipping".localized() }
        let government = { "government".localized() }
        let institution = { "institution".localized() }
    }
    
    struct OrganizationProfile {
        let unselect_all = { "unselect_all".localized() }
        let select_all = { "select_all".localized() }
        let organization_profile = { "organization_profile".localized() }
        let share_data = { "share_data".localized() }
        let share_my_profile = { "share_my_profile".localized() }
        let please_select_check_box_and_share_your_data = { "please_select_check_box_and_share_your_data".localized() }
        let please_update_any_value = { "please_update_any_value".localized() }
    }
    
    struct ShareData {
        let shared = { "shared".localized() }
        let data_to = { "data_to".localized() }
        let data_shared_on = { "data_shared_on".localized() }
        let details = { "details".localized() }
    }
    
    struct Notifications {
        let notification = { "notification".localized() }
        let notifications = { "notifications".localized() }
        let remove_notification = { "remove_notification".localized() }
        let block_notification = { "block_notification".localized() }
    }
    
    struct Settings {
        let gdpr_policy = { "gdpr_policy".localized() }
        let popia_policy = { "popia_policy".localized() }
        let app_lock = { "app_lock".localized() }
        let data_access_request = { "data_access_request".localized() }
        let data_protection = { "data_protection".localized() }
        let data_protection_policy = { "data_protection_policy".localized() }
        let delete_all_trsuted_organization = { "delete_all_trsuted_organization".localized() }
        let delete_my_account = { "delete_my_account".localized() }
        let setting = { "setting".localized() }
        let blocked = { "blocked".localized() }
        let remove_all_trusted_organization_popup_title = { "remove_all_trusted_organization_popup_title".localized() }
        let delete_all_organizations = { "delete_all_organizations".localized() }
        let remove_all_trusted_organization_confirmation_popup_title = { "remove_all_trusted_organization_confirmation_popup_title".localized() }
        let remove_all_trusted_organization_confirmation_popup_first_option = { "remove_all_trusted_organization_confirmation_popup_first_option".localized() }
        let remove_all_trusted_organization_confirmation_popup_second_option = { "remove_all_trusted_organization_confirmation_popup_second_option".localized() }
        let trusted_organization_are_deleted = { "trusted_organization_are_deleted".localized() }
        let okay = { "okay".localized() }
        let delete = { "delete".localized() }
        let remove_my_profile_confirmation_popup_title = { "remove_my_profile_confirmation_popup_title".localized() }
        let remove_my_profile_confirmation_popup_first_option = { "remove_my_profile_confirmation_popup_first_option".localized() }
        let remove_my_profile_confirmation_popup_second_title = { "remove_my_profile_confirmation_popup_second_title".localized() }
        let remove_my_profile_confirmation_popup_second_option = { "remove_my_profile_confirmation_popup_second_option".localized() }
        let remove_my_profile_confirmation_popup_third_option = { "remove_my_profile_confirmation_popup_third_option".localized() }
        let my_profile_deleted = { "my_profile_deleted".localized() }
        let notification_settings = { "notification_settings".localized() }
        let remove_my_trusted_organization_confirmation_popup_title =
        { "remove_my_trusted_organization_confirmation_popup_title".localized() }
        let remove_my_trusted_organization_confirmation_popup_first_option =
        { "remove_my_trusted_organization_confirmation_popup_first_option".localized() }
        let remove_my_trusted_organization_confirmation_popup_second_option =
        { "remove_my_trusted_organization_confirmation_popup_second_option".localized() }
        let my_trusted_organization_is_deleted =
        { "my_trusted_organization_is_deleted".localized() }
                
    }
    
    struct MyAccount {
        let two_step_verification = { "two_step_verification".localized() }
        let language = { "language".localized() }
    }
    
    struct Help {
        let help = { "help".localized() }
        let help_center = { "help_center".localized() }
        let contact_us = { "contact_us".localized() }
        let terms_and_privacy_policy = { "terms_and_privacy_policy".localized() }
        let app_info = { "app_info".localized() }
        let disclaimer = { "disclaimer".localized() }
    }
    
    struct Menu {
        let activity_log = { "activity_log".localized() }
        let log_out = { "log_out".localized() }
    }
    
    struct AppLock {
        let password = { "password".localized() }
        let delay = { "delay".localized() }
        let thirty_second = { "30_second".localized() }
        let sixty_second = { "60_second".localized() }
        let two_minute = { "2_minute".localized() }
        let five_minute = { "5_minute".localized() }
        let other_options = { "other_options".localized() }
        let set_pin = { "set_pin".localized() }
        let set_face_id = { "set_face_id".localized() }
        let set_fingerprint = { "set_fingerprint".localized() }
        let type_of_notification = { "type_of_notification".localized() }
        let alerts = { "alerts".localized() }
        let updates = { "updates".localized() }
        let data_insights = { "data_insights".localized() }
        let in_app = { "in_app".localized() }
        let push_notification = { "push_notification".localized() }
        let sms = { "sms".localized() }
    }
    
    struct ReportReason {
        let report_reason_title = { "report_reason_title".localized() }
        let support_center_email = { "support_center_email".localized() }
        let enter_here = { "enter_here".localized() }
        let write_here = { "write_here".localized() }
        let description = { "description".localized() }
        let report = { "report".localized() }
    }
    
    struct BlockReason {
        let block_reason_title = { "block_reason_title".localized() }
        let block_reason_description = { "block_reason_description".localized() }
        let block = { "block".localized() }
    }
    
    struct TwoStepVerification {
        let security_questions = { "security_questions".localized() }
        let two_factor_authentication  = { "two_factor_authentication".localized() }
    }
    
    struct ImagePicker {
        let camera = { "camera".localized() }
        let gallery = { "gallery".localized() }
        let image_selection_message = { "image_selection_message".localized() }
    }
    
    struct Scanner {
        let align_qr_code = { "align_qr_code".localized() }
        let select_from_gallery = { "select_from_gallery".localized() }
    }
    
    struct BlockOrganization {
        let blocked = { "blocked".localized() }
        let unblock = { "unblock".localized() }
    }
    
    struct Synchronization {
        let profile_data_synchronization = { "profile_data_synchronization".localized() }
        let disabled_description = { "disabled_description".localized() }
    }
    
    struct DataSubjectAccessRequest {
        let download_report = { "download_report".localized() }
        let download_description = { "download_description".localized() }
        let dsar_description = { "dsar_description".localized() }
        let dsar_description_title = { "dsar_description_title".localized() }
        let dsar = { "dsar".localized() }
    }
    
    struct VersionUpdate {
        let update_now = { "update_now".localized() }
    }
}

struct WebviewUrl {
    struct Help {
        static let help_center = "https://addressfull.com/how-it-works/#FAQ"
        static let contact_us = "https://addressfull.com/contact/"
        static let terms_and_privacy_policy = "https://addressfull.com/privacy-policy/"
        static let app_info = "https://addressfull.com/app-information/"
    }
}

struct NotificationName {
    static let reload_home_vc = "reload_home_vc"
    static let reload_top_trusted_vc = "reload_top_trusted_vc"
    static let reload_notification_vc = "reload_notification_vc"
    static let reload_all_views = "reload_all_views"
    static let data_synchronized = "data_synchronized"
    static let login_popup = "login_popup"
}

struct NotificationUserInfo {
    static let message = "message"
}

struct ApiHeaderAndParameters {
    static let search = "search"
    static let page = "page"
    static let page_size = "page_size"
    static let lat = "lat"
    static let lon = "lon"
    static let id = "id"
    static let timezone = "timezone"
    static let req_period = "req_period"
    static let bookmark = "bookmark"
    static let start_date = "start_date"
    static let end_date = "end_date"
    static let sort_order = "sort_order"
    static let type = "type"
    static let s_api_key = "s_api_key"
    static let x_api_key = "x_api_key"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let mobileNumber = "mobileNumber"
    static let address = "address"
    static let email = "email"
    static let linkedin = "linkedin"
    static let twitter = "twitter"
    static let social_links = "social_links"
    static let is_read = "is_read"
    static let asc = "asc"
    static let desc = "desc"
}

struct Message {
    static let something_went_wrong = { "something_went_wrong".localized() }
    static let network_not_available = { "netowrk_not_available".localized() }
    static let two_step_verification_added_successfully = { "two_step_verification_added_successfully".localized() }
    static let two_step_verification_updated_successfully = { "two_step_verification_updated_successfully".localized() }
    static let two_step_verification_wrong_answer = { "two_step_verification_wrong_answer".localized() }
    static let two_step_verification_delete_message = { "two_step_verification_delete_message".localized() }
    static let two_step_verification_deleted_suucessfully = { "two_step_verification_deleted_suucessfully".localized() }
    static let add_biometric_authentication_message = { "add_biometric_authentication_message".localized() }
    static let are_you_sure_you_want_to_log_out = { "are_you_sure_you_want_to_log_out".localized() }
    static let are_you_sure_you_want_to_reject_the_request = { "are_you_sure_you_want_to_reject_the_request".localized() }
    static let upgrade_your_os_version = { "upgrade_your_os_version".localized() }
    static let failed_to_open_camera = { "failed_to_open_camera".localized() }
    static let invalid_image = { "invalid_image".localized() }
    static let invalid_qr = { "invalid_qr".localized() }
    static let for_your_security_you_can_only_use_when_its_unlock = { "for_your_security_you_can_only_use_when_its_unlock".localized() }
    static let login_successfully = { "login_successfully".localized() }
    static let logout_successfully = { "logout_successfully".localized() }
    static let register_successfully = { "register_successfully".localized() }
    static let your_account_deleted_successfully = { "your_account_deleted_successfully".localized() }
    static let profile_updated_successfully = { "profile_updated_successfully".localized() }
    static let no_data_found = { "no_data_found".localized() }
    static let no_match_found = { "no_match_found".localized() }
    static let does_not_have_access_to_your = { "does_not_have_access_to_your".localized() }
    static let to_enable_acces_tap_settings_and_turn_on = { "to_enable_acces_tap_settings_and_turn_on".localized() }
    static let please_enter_another = { "please_enter_another".localized() }
    static let to_delete_this = { "to_delete_this".localized() }
    static let are_you_sure_you_want_to_delete_the = { "are_you_sure_you_want_to_delete_the".localized() }
    static let are_you_sure_you_want_to_go_back = { "are_you_sure_you_want_to_go_back".localized() }
    static let discard_changes = { "discard_changes".localized() }
    static let please_wait = { "discard_changes".localized() }
    static let are_you_sure_you_want_to_save_profile = { "are_you_sure_you_want_to_save_profile".localized() }
    static let your_data_will_update_accross_all_your_trusted_organizations = { "your_data_will_update_accross_all_your_trusted_organizations".localized() }
    static let multiple_device_found = { "multiple_device_found".localized() }
    static let you_are_about_to_share_your_data_with = { "you_are_about_to_share_your_data_with".localized() }
    static let would_you_like_to_go_ahead = { "would_you_like_to_go_ahead".localized() }
    static let you_have_already_shared_your_data_with = { "you_have_already_shared_your_data_with".localized() }
    static let would_you_like_to_update = { "would_you_like_to_update".localized() }
    static let unregistered_user_need_to_signup_first = { "unregistered_user_need_to_signup_first".localized() }
    static let an_account_already_exists = { "an_account_already_exists".localized() }
    static let account_has_been_deactivated_on_your_request = { "account_has_been_deactivated_on_your_request".localized() }
    static let your_session_has_been_expired = { "your_session_has_been_expired".localized() }
    static let new_version_available_title = { "new_version_available_title".localized() }
    static let new_version_available_message = { "new_version_available_message".localized() }
}


struct ValidationMessage {
    static let please_enter_first_name = { "please_enter_first_name".localized() }
    static let please_enter_valid_first_name = { "please_enter_valid_first_name".localized() }
    static let please_enter_last_name = { "please_enter_last_name".localized() }
    static let please_enter_valid_last_name = { "please_enter_valid_last_name".localized() }
    static let please_enter_mobile_number = { "please_enter_mobile_number".localized() }
    static let should_be_between_6_to_13_characters = { "should_be_between_6_to_13_characters".localized() }
    static let please_accept_gdpr_compliance = { "please_accept_gdpr_compliance".localized() }
    static let please_enter_email = { "please_enter_email".localized() }
    static let please_enter_valid_email = { "please_enter_valid_email".localized() }
    static let please_enter_address = { "please_enter_address".localized() }
    static let please_enter_valid_address = { "please_enter_valid_address".localized() }
    static let please_enter_valid_linked_in_link = { "please_enter_valid_linked_in_link".localized() }
    static let please_enter_valid_twitter_link = { "please_enter_valid_twitter_link".localized() }
    static let please_enter_otp = { "please_enter_otp".localized() }
    static let please_enter_valid_otp = { "please_enter_valid_otp".localized() }
    static let please_enter_two_step_verification_answer = { "please_enter_two_step_verification_answer".localized() }
    static let please_select_two_step_verification_question = { "please_select_two_step_verification_question".localized() }
    static let please_add_two_step_verification_question = { "please_add_two_step_verification_question".localized() }
    static let please_select_atleast_one_data_to_share = { "please_select_atleast_one_data_to_share".localized() }
    static let you_can_add_maximum = { "you_can_add_maximum".localized() }
    static let you_need_to_select_atlease_one_mobile_number_and_one_email = { "you_need_to_select_atlease_one_mobile_number_and_one_email".localized() }
    static let please_enter_start_date_and_end_date = { "please_enter_start_date_and_end_date".localized() }
    static let you_can_not_modify_this_data = { "you_can_not_modify_this_data".localized() }
    static let please_provide_reason_for_block = { "please_provide_reason_for_block".localized() }
}
