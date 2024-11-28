//
//  Structs.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


///This struct is being used to check length validation
struct ValaidationLength {
    let otp = 4
    let min_mobile_number = 6
    let max_mobile_number = 13
}

///This struct is being used to check token validity time
struct TokenValidity {
    let local = 1
    let jwt = 7
}


///This struct is being used to check onboarding screen auto scroll time
struct OnboardingScreenAutoScroll {
    let time = TimeInterval(integerLiteral: 5) 
}

///This struct is being used to check maximum profile data count
struct MaximumProfileData {
    let count = 5
}

///This struct is being used into form field validation check to return whether validation is successfull or thrown an error
struct ValidationResult {
    var is_success: Bool
    var str_error_message: String?
    var section: Int? = nil
    var row: Int? = nil
}


/// This struct is being used for application information. like, app name and other details
struct AppInfo {
    static let app_name = "AddressFull"
}


/// This struct is being used to check device
struct DeviceSize  {
    static let IS_IPHONE_4_5_5S_SE_5C = UIScreen.main.bounds.height == 568.0 ? true : false
    static let IS_IPHONE_6_7_6S_7_8 = UIScreen.main.bounds.height == 667.0 ? true : false
    static let IS_IPHONE_6P_7P_8PFAMILY = UIScreen.main.bounds.height >= 736.0 ? true : false
    static let IS_IPHONE_X_11PFAMILY = UIScreen.main.bounds.height == 812.0 ? true : false
    static let IS_IPHONE_XR_XSMAX_11_11PMFAMILY = UIScreen.main.bounds.height == 896.0 ? true : false
    static let IS_IPHONE_12PMFAMILY = UIScreen.main.bounds.height == 926.0 ? true : false
    static let IS_IPHONE_12_12PFAMILY = UIScreen.main.bounds.height == 844.0 ? true : false
    static let IS_IPHONE_12MFAMILY = UIScreen.main.bounds.height == 780.0 ? true : false
}


struct KeyChainKey {
    static let private_key = "private_key"
    static let public_key = "public_key"
    static let server_public_key = "server_public_key"
    static let group = "com.addressFull.app"
    static let device_id = "device_id"
}


struct AppColor {
    static let primary_green = { UIColor(red: 0, green: 176, blue: 0) }
    static let primary_red = { UIColor(red: 213, green: 0, blue: 0) }
    static let primary_gray = { UIColor(red: 247, green: 247, blue: 249) }
    static let primary_light_gray = { UIColor(red: 255, green: 255, blue: 255) }
    static let seperator_gray = { UIColor(red: 218, green: 218, blue: 218) }
    
    static let placeholder_text_color = { UIColor(red: 118, green: 118, blue: 118) }
    static let textfield_border_color = { UIColor(red: 170, green: 170, blue: 170) }
    static let button_background_color = { UIColor(red: 233, green: 233, blue: 233) }
    static let otp_box_background_color = { UIColor(red: 196, green: 196, blue: 196) }
    
    static let light_gray = { UIColor(red: 248, green: 248, blue: 248) }
    static let segment_selected_gray = { UIColor(red: 206, green: 206, blue: 206) }
    
    static let label_text_color = { UIColor(red: 17, green: 17, blue: 17) }
    static let text_grey_color = { UIColor(red: 112, green: 123, blue: 129) }
    static let toast_bg_color = { UIColor(red: 75, green: 75, blue: 75) }
}


struct UserDefaultsKey {
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let mobile_number = "mobile_number"
    static let country_code = "country_code"
    static let selected_language_key = "SelectedLanguageKey"
    static let is_onboarding_finished = "isOnboardingFinished"
    static let last_stored_two_step_verification_question_answer_index = "lastStoredTwoStepVerificationQuestionAnswerIndex"
    static let last_stored_first_name_index = "lastStoredFirstNameIndex"
    static let last_stored_last_name_index = "lastStoredLastNameIndex"
    static let last_stored_logged_user_personal_index_of_email = "last_stored_logged_user_personal_index_of_email"
    static let last_stored_logged_user_personal_index_of_mobile_number = "last_stored_logged_user_personal_index_of_mobile_number"
    static let last_stored_logged_user_personal_index_of_address = "last_stored_logged_user_personal_index_of_address"
    static let last_stored_logged_user_personal_index_of_social_links = "last_stored_logged_user_personal_index_of_social_links"
    static let password_attempts = "password_attempts"
    static let remaining_time = "remaining_time"
    static let time_after_two_mins = "time_after_two_mins"
    static let otp_resent_count = "otp_resent_count"
    static let app_lock_duration = "app_lock_duration"
    static let new_updated_profile_data = "updated_profile_data"
    static let new_deleted_profile_data = "new_deleted_profile_data"
    static let sync_data_completed = "sync_data_completed"
    static let auto_sync_api_status = "auto_sync_api_status"
    static let last_opened_date = "last_opened_date"
}

struct AssetsImage {
    static let accept_right = "accept_right"
    static let block = "block"
    static let checkbox_checked = "checkbox_checked"
    static let checkbox_checked_grey = "checkbox_checked_grey"
    static let checkbox_unchecked = "checkbox_unchecked"
    static let light_checkbox_unchecked = "light_checkbox_unchecked"
    static let cross = "cross"
    static let delete = "delete"
    static let face_id = "face_id"
    static let fingerprint = "fingerprint"
    static let gdpr_logo = "gdpr_logo"
    static let information_filled = "information-filled"
    static let menu = "menu"
    static let home_filled = "home_filled"
    static let help_filled = "help_filled"
    static let logout = "logout"
    static let my_profile_filled = "my_profile_filled"
    static let notifications_filled = "notifications_filled"
    static let trusted_org_filled = "trusted_org_filled"
    static let activity_log_selected = "activity_log_selected"
    static let activity_log_unselected = "activity_log_unselected"
    static let data_access_request_filled = "data_access_request_filled"
    static let more_vertical = "more-vertical"
    static let placeholder = "placeholder"
    static let profile_avatar = "profile_avatar"
    static let reject_cross = "reject_cross"
    static let report = "report"
    static let search_icon = "search_icon"
    static let splash_icon = "splash_icon"
    static let home_selected = "home_selected"
    static let home_unselected = "home_unselected"
    static let my_trusted_selected = "my_trusted_selected"
    static let my_trusted_unselected = "my_trusted_unselected"
    static let setting_selected = "setting_selected"
    static let setting_unselected = "setting_unselected"
    static let notification_selected = "notification_selected"
    static let notification_unselected = "notification_unselected"
    static let download = "download"
    static let profile_selected = "profile_selected"
    static let profile_unselected = "profile_unselected"
    static let dsar_selected = "dsar_selected"
    static let dsar_unselected = "dsar_unselected"
    static let white_background = "white_background"
    static let rounded_green_checked = "rounded_green_checked"
    static let rounded_unchecked = "rounded_unchecked"
    static let edit_pencil = "edit_pencil"
    static let big_checkmark_checked = "big_checkmark_checked"
    static let back_arrow = "back_arrow"
    static let profile_placeholder = "profile_placeholder"
    static let receipt = "receipt"
    static let right_arrow_green = "right_arrow_green"
    static let onboarding_one = "onboarding_one"
    static let onboarding_two = "onboarding_two"
    static let onboarding_three = "onboarding_three"
    static let onboarding_four = "onboarding_four"
    static let onboard_slider_one = "onboard_slider_one"
    static let onboard_slider_two = "onboard_slider_two"
    static let onboard_slider_three = "onboard_slider_three"
    static let onboard_slider_four = "onboard_slider_four"
    static let app_logo_green = "app_logo_green"
    static let app_lock = "app_lock"
    static let delete_my_account = "delete_my_account"
    static let notification_round = "notification_round"
    static let contact = "contact"
    static let exclaimation = "exclaimation"
    static let terms = "terms"
    static let linkedin = "linkedin"
    static let twitter = "twitter"
    static let qr_scanner = "qr_scanner"
    static let security_questions = "security_questions"
    static let gdpr_settings = "gdpr_settings"
    static let dropdown_arrow = "dropdown_arrow"
    static let popia_policy = "popia_policy"
    static let gdpr_policy = "gdpr_policy"
    static let data_protection_policy = "data_protection_policy"
    static let delete_icon_big = "delete_icon_big"
    static let report_big = "report_big"
}


struct AppFont {
    static let redactedScript_regular = "RedactedScript-Regular"
    static let helvetica_regular = "Helvetica-Regular"
    static let helvetica_bold = "Helvetica-Bold"
    static let helvetica_boldOblique = "Helvetica-BoldOblique"
    static let helvetica_compressed = "Helvetica-Compressed"
    static let helvetica_light = "Helvetica-Light"
    static let helvetica_oblique = "Helvetica-Oblique"
    static let helvetica_roundedBold = "Helvetica-RoundedBold"
    static let poppins_light = "Poppins-Light"
    static let poppins_semiBold = "Poppins-SemiBold"
}


struct CoreDataBase {
    struct Entity {
        struct TwoStepVerificationQuestion {
            static let entity_name = "TwoStepVerificationQuestion"
            
            struct Fields {
                static let user_id = "user_id"
                static let question_id = "question_id"
                static let question = "question"
                static let answer = "answer"
            }
            
            func getLastStoredIndex() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_two_step_verification_question_answer_index) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndex(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_two_step_verification_question_answer_index)
            }
        }
        
        struct LoggedUserDetails {
            static let entity_name = "LoggedUserDetails"
            
            struct Fields {
                static let country_code = "country_code"
                static let mobile_number = "mobile_number"
                static let token = "token"
                static let image = "image"
            }
        }
        
        struct LoggedUserPersonalDetails {
            static let entity_name = "LoggedUserPersonalDetails"
            
            struct Fields {
                static let field_id = "field_id"
                static let user_id = "user_id"
                static let type_of_field = "type_of_field"
                static let type_of_value = "type_of_value"
                static let value = "value"
                static let is_selected = "is_selected"
                static let country_code = "country_code"
            }
            
            func getLastStoredIndexOfFirstName() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_first_name_index) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfFirstName(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_first_name_index)
            }
            
            func getLastStoredIndexOfLastName() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_last_name_index) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfLastName(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_last_name_index)
            }
            
            func getLastStoredIndexOfEmail() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_email) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfEmail(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_email)
            }
            
            func getLastStoredIndexOfAddress() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_address) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfAddress(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_address)
            }
            
            func getLastStoredIndexOfMobileNumber() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_mobile_number) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfMobileNumber(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_mobile_number)
            }
            
            func getLastStoredIndexOfSocialLinks() -> Int? {
                if let data = UserDefaults.standard.value(forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_social_links) as? Int {
                    return data
                }
                return nil
            }
            
            func setLastStoredIndexOfSocialLinks(value : Int) {
                UserDefaults.standard.setValue(value, forKey: UserDefaultsKey.last_stored_logged_user_personal_index_of_social_links)
            }
        }
        
    }
}
