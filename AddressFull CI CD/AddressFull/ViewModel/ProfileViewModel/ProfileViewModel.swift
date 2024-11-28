//
//  ProfileViewModel.swift
//  AddressFull
//
//  Created by Sneh on 11/24/23.
//

import Foundation
import CoreData
import UIKit


class ProfileViewModel {
    
    // MARK: -  PERSONAL DETAILS - (SHARABLE) -
    
    /// This function will be used to validate textfield's data
    func validate(request_model: PersonalDetailsModel) -> ValidationResult {
        
        let mobile_numbers = request_model.arr_mobile_numbers
        let emails = request_model.arr_email
        let addresses = request_model.arr_address
        let social_links = request_model.arr_social_links
        
        
        // CHECK NAME VALIDATION
        if request_model.first_name.value.isBlank {
            
            return ValidationResult(is_success: false,
                                    str_error_message: ValidationMessage.please_enter_first_name(),
                                    section: 1)
            
        } else if request_model.first_name.value.isValidName {
            
            return ValidationResult(is_success: false,
                                    str_error_message: ValidationMessage.please_enter_valid_first_name(),
                                    section: 1)
            
        } else if request_model.last_name.value.isBlank {
            
            return ValidationResult(is_success: false,
                                    str_error_message: ValidationMessage.please_enter_last_name(),
                                    section: 2)
            
        } else if request_model.last_name.value.isValidName {
            
            return ValidationResult(is_success: false,
                                    str_error_message: ValidationMessage.please_enter_valid_last_name(),
                                    section: 2)
            
        }
        
        
        // CHECK MOBILE NUMBER VALIDATION
        for (index,mobile_number) in mobile_numbers.enumerated() {
            if mobile_number.value.isBlank {
                
                return ValidationResult(is_success: false,
                                        str_error_message: "\(ValidationMessage.please_enter_mobile_number()) \(index + 1)",
                                        section: 3,
                                        row: index)
                
            }
            else if mobile_number.value.count < ValaidationLength().min_mobile_number || mobile_number.value.count > ValaidationLength().max_mobile_number {
                
                return ValidationResult(is_success: false,
                                        str_error_message: "\(LocalText.SignUpScreen().mobile_number()) \(index + 1) \(ValidationMessage.should_be_between_6_to_13_characters())",
                                        section: 3,
                                        row: index)
                
            }
        }
        
        
        // CHECK EMAIL VALIDATION
        for (index,email_address) in emails.enumerated() {
            if email_address.value.isBlank {
                
                return ValidationResult(is_success: false,
                                        str_error_message: "\(ValidationMessage.please_enter_email()) \(index + 1)",
                                        section: 4,
                                        row: index)
                
            }
            else if !email_address.value.isValidEmailID {
                
                return ValidationResult(is_success: false,
                                        str_error_message: "\(ValidationMessage.please_enter_valid_email()) \(index + 1)",
                                        section: 4,
                                        row: index)
                
            }
        }
        
        
        // CHECK ADDRESS VALIDATION
        for (index,street_address) in addresses.enumerated() {
            if street_address.value.isBlank {
                
                return ValidationResult(is_success: false,
                                        str_error_message: "\(ValidationMessage.please_enter_address()) \(index + 1)",
                                        section: 5,
                                        row: index)
                
            }
        }
        
        
        // CHECK SOCIAL LINKS VALIDATION
        for (index,social_link) in social_links.enumerated() {
            if index == 0 && social_link.value != "" {
                if !social_link.value.isValidLinkedInURL() {
                    
                    return ValidationResult(is_success: false,
                                            str_error_message: ValidationMessage.please_enter_valid_linked_in_link(),
                                            section: 6,
                                            row: index)
                    
                }
            } else if index == 1 && social_link.value != "" {
                if !social_link.value.isValidTwitterURL() {
                    
                    return ValidationResult(is_success: false,
                                            str_error_message: ValidationMessage.please_enter_valid_twitter_link(),
                                            section: 6,
                                            row: index)
                    
                }
            }
        }
        
        return ValidationResult(is_success: true, str_error_message: "")
    }
    
    
    /// Use this function to save user personal details like phone, email, address
    func saveLoggedUserPersonalDetails(userID: String,profile_model: PersonalDetailsModel) -> Bool {
        
        var isDataAdded = false
        
        if let data = profile_model.first_name.toJson() {
            if profile_model.first_name.field_id != "" {
                let updated_value = profile_model.first_name
                isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: updated_value)
            } else {
                let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfFirstName()
                let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                if isDataAdded {
                    CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfFirstName(value: newIndex)
                }
            }
            
            UserDetailsModel.shared.first_name = profile_model.first_name.value
        }
        
        if let data = profile_model.last_name.toJson() {
            if profile_model.last_name.field_id != "" {
                let updated_value = profile_model.last_name
                isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: updated_value)
            } else {
                let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfLastName()
                let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                if isDataAdded {
                    CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfLastName(value: newIndex)
                }
            }
            
            UserDetailsModel.shared.last_name = profile_model.last_name.value
        }
        
        profile_model.arr_address.forEach { model in
            if let data = model.toJson() {
                if model.field_id != "" {
                    var updated_value = model
                    updated_value.value = updated_value.value.replacingOccurrences(of: "\n", with: ",")
                    isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: updated_value)
                } else {
                    let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfAddress()
                    let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                    isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                    if isDataAdded {
                        CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfAddress(value: newIndex)
                    }
                }
            }
        }
        
        profile_model.arr_email.forEach { model in
            if let data = model.toJson() {
                if model.field_id != "" {
                    isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: model)
                } else {
                    let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfEmail()
                    let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                    isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                    if isDataAdded {
                        CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfEmail(value: newIndex)
                    }
                }
            }
        }
        
        profile_model.arr_mobile_numbers.forEach { model in
            if let data = model.toJson() {
                if model.field_id != "" {
                    isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: model)
                } else {
                    let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfMobileNumber()
                    let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                    isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                    if isDataAdded {
                        CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfMobileNumber(value: newIndex)
                    }
                }
            }
        }
        
        profile_model.arr_social_links.forEach { model in
            if let data = model.toJson() {
                if model.field_id != "" {
                    isDataAdded = self.updateLoggedUserPersonalDetails(userID: userID, model: model)
                } else {
                    let lastIndex = CoreDataBase.Entity.LoggedUserPersonalDetails().getLastStoredIndexOfSocialLinks()
                    let newIndex  = lastIndex == nil ? 0 : ((lastIndex ?? 0) + 1)
                    isDataAdded =  self.addNewValueInPersonalDetails(userID: userID, data: data, newIndex: newIndex)
                    if isDataAdded {
                        CoreDataBase.Entity.LoggedUserPersonalDetails().setLastStoredIndexOfSocialLinks(value: newIndex)
                    }
                }
            }
        }
        
        return isDataAdded
    }
    
    
    /// Use this function to retrive user personal details like phone, email, address
    func retrieveLoggedUserPersonalDetails(country_code: String, mobile_number: String) -> PersonalDetailsModel? {
        
        ProfileViewModel().retriveSavedLoggedUserDetails(country_code: country_code, mobile_number: mobile_number)
        
        let predection = [CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.user_id : "\(country_code) \(mobile_number)"]
        
        let loggedUserPersonalData = CoreDataManager.retriveData(withPrediction: predection, forEntityName: CoreDataBase.Entity.LoggedUserPersonalDetails.entity_name)
        
        if loggedUserPersonalData.0, let data = loggedUserPersonalData.1 as? [NSManagedObject] {
            
            var logged_user_personal_details = PersonalDetailsModel(
                first_name: ProfileDataModel(type_of_field: LocalText.Profile().first_name(),
                                             type_of_value: LocalText.Profile().first_name(),
                                             value: UserDetailsModel.shared.first_name),
                last_name: ProfileDataModel(type_of_field: LocalText.Profile().last_name(),
                                            type_of_value: LocalText.Profile().last_name(),
                                            value: UserDetailsModel.shared.last_name),
                image: UserDetailsModel.shared.image,
                arr_mobile_numbers: [],
                arr_email: [],
                arr_address: [],
                arr_social_links: [])
            
            data.forEach { nsManagedObject in
                var model = ProfileDataModel(type_of_field: "", type_of_value: "", value: "")
                
                if let field_id = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.field_id) as? String {
                    model.field_id = field_id
                }
                
                if let is_selected = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.is_selected) as? Bool {
                    model.is_selected = is_selected
                }
                
                if let type_of_field = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.type_of_field) as? String {
                    model.type_of_field = type_of_field
                }
                
                if let type_of_value = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.type_of_value) as? String {
                    model.type_of_value = type_of_value
                }
                
                if let country_code = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.country_code) as? String {
                    model.country_code = country_code
                } else {
                    model.country_code = Country.getCurrentCountry()?.code
                }
                
                if (nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.value) as? String) != nil || model.type_of_field == LocalText.MyProfile().social() {
                    
                    let value = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.value) as? String ?? ""
                    
                    if model.type_of_value == LocalText.Profile().first_name() {
                        UserDetailsModel.shared.first_name = value
                    } else if model.type_of_value == LocalText.Profile().last_name() {
                        UserDetailsModel.shared.last_name = value
                    }
                    
                    model.value = value.replacingOccurrences(of: "\n", with: ",")
                }
                
                if model.type_of_field != "" && model.type_of_value != "" && (model.value != "" || model.type_of_field == LocalText.MyProfile().social()) {
                    
                    if model.type_of_field == LocalText.Profile().first_name() {
                        logged_user_personal_details.first_name = model
                        
                    } else if model.type_of_field == LocalText.Profile().last_name() {
                        logged_user_personal_details.last_name = model
                        
                    } else if model.type_of_field == LocalText.PersonalDetails().mobile_number() {
                        logged_user_personal_details.arr_mobile_numbers.append(model)
                        
                    } else if model.type_of_field == LocalText.PersonalDetails().email() {
                        logged_user_personal_details.arr_email.append(model)
                        
                    } else if model.type_of_field == LocalText.PersonalDetails().address() {
                        logged_user_personal_details.arr_address.append(model)
                        
                    } else if model.type_of_field == LocalText.MyProfile().social() {
                        logged_user_personal_details.arr_social_links.append(model)
                        
                    }
                }
            }
            
            return logged_user_personal_details.arr_address.count > 0 && logged_user_personal_details.arr_email.count > 0 && logged_user_personal_details.arr_mobile_numbers.count > 0 ? logged_user_personal_details : nil
        }
        return nil
    }
    
    
    /// Use this function to add new personal details of user  like phone, email, address
    func addNewValueInPersonalDetails(userID: String,data: [String:Any],newIndex: Int) -> Bool {
        var data = data
        data[CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.user_id] = userID
        data[CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.field_id] = "\(newIndex)"
        return  CoreDataManager.add(data: data, forEntityName: CoreDataBase.Entity.LoggedUserPersonalDetails.entity_name)
    }
    
    
    /// Use this function to update user personal details like phone, email, address
    func updateLoggedUserPersonalDetails(userID: String, model: ProfileDataModel) -> Bool {
        let predection = [
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.user_id : userID,
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.field_id : model.field_id,
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.type_of_field : model.type_of_field
        ] as [String : Any]
        
        if let data = model.toJson() {
            let isDataUpdated =  CoreDataManager.update(data: data,withPrediction: predection, forEntityName: CoreDataBase.Entity.LoggedUserPersonalDetails.entity_name)
            print("Is Personal details user data updated - \(isDataUpdated)")
            return isDataUpdated
        }
        return false
    }
    
    
    /// Use this function to delete user personal details like phone, email, address
    func deleteLoggedUserPersonalDetails(userID: String, model: ProfileDataModel) -> Bool {
        let data = [
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.user_id : userID,
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.field_id : model.field_id,
            CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.type_of_field : model.type_of_field
        ] as [String : Any]
        
        return CoreDataManager.delete(withPrediction: data, forEntityName: CoreDataBase.Entity.LoggedUserPersonalDetails.entity_name)
    }
    
    
    // MARK: - LOGIN DETAILS - (NOT SHARABLE) -
    
    /// Use this function to save user  details like primary mobile number, token
    func saveLoggedUserDetails(countryCode: String, mobileNumber: String, token: String) -> Bool {
        let data = [
            CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : countryCode,
            CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : mobileNumber,
            CoreDataBase.Entity.LoggedUserDetails.Fields.token : token
        ] as [String : Any]
        
        return CoreDataManager.add(data: data, forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
    }
    
    
    /// Use this function to retrive user  details like primary mobile number, first name, last name
    func retriveSavedLoggedUserDetails(country_code: String, mobile_number: String) {
        
        let loggedUserDetails = CoreDataManager.retriveData(withPrediction:
                                                                [
                                                                    CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : mobile_number,
                                                                    CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : country_code
                                                                ],
                                                            forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
        
        if loggedUserDetails.0, let data = (loggedUserDetails.1 as? [NSManagedObject]) {
            
            data.forEach { nsManagedObject in
                
                if let token = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserDetails.Fields.token) as? String {
                    
                    UserDetailsModel.shared.token = token
                    
                    if let country_code = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserDetails.Fields.country_code) as? String {
                        UserDetailsModel.shared.country_code = country_code
                        UserDefaults.standard.setValue(country_code, forKey: UserDefaultsKey.country_code)
                    }
                    
                    if let mobile_number = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number) as? String {
                        UserDetailsModel.shared.mobile_number = mobile_number
                        UserDefaults.standard.setValue(mobile_number, forKey: UserDefaultsKey.mobile_number)
                    }
                    
                    if let image = nsManagedObject.value(forKey: CoreDataBase.Entity.LoggedUserDetails.Fields.image) as? Data {
                        UserDetailsModel.shared.image = image
                    }
                }
            }
        }
    }
    
    
    /// Use this function to update user  details like primary first name, last name
    func updateLoggedUserDetails(image: Data? = nil, token: String? = nil) -> Bool {
        
        let withPrediction : [String : Any] = [
            CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : UserDetailsModel.shared.mobile_number,
            CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : UserDetailsModel.shared.country_code
        ]
        
        print("withPrediction - \(withPrediction)")
        
        var data : [String : Any] = [:]
        
        if let img = image {
            data[CoreDataBase.Entity.LoggedUserDetails.Fields.image] = img
        }
        
        if let token = token {
            data[CoreDataBase.Entity.LoggedUserDetails.Fields.token] = token
        }
        
        print("data - \(data)")
        
        let is_user_data_updated = CoreDataManager.update(data: data, withPrediction: withPrediction, forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
        
        print("is_user_data_updated - \(is_user_data_updated)")
        
        return is_user_data_updated
    }
    
    
    //MARK: - API CALL -
    
    /// Use this function to share data to organization
    func syncData(sync_data_model : SyncDataRequestBaseModel,
                  view_for_progress_indicator: UIView,
                  completionHandler: @escaping((_ is_success: Bool, _ model: SignupResponseModel?) -> Void)) {
        
        var request = ""
        
        if let new_request = EncryptionDecryption.encryptRequest(sync_data_model) {
            request = new_request
        }
        
        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall(
            SignupResponseModel.self,
            to: .auto_sync,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator,
            encryptedRequest: request)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                view_for_progress_indicator.showProgressBar()
                
                EncryptionDecryption.decryptResponse(SignupResponseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    
                    view_for_progress_indicator.hideProgressBar()
                    
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        completionHandler(false,nil)
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
                
            } else if let model = responseModel, isSuccess {
                completionHandler(true,model)
                
            }
            else {
                completionHandler(false,nil)
                UtilityManager().showToast(message: errorMessage ?? "")
                
            }
        }
    }
    
    
    // MARK: - SAVE DATA AFTER SYNCHRONIZATION -
    
    func setProfileData(status: Bool) {
        
        if status {
            if let saved_new_data = UserDefaults.standard.value(forKey: UserDefaultsKey.new_updated_profile_data) as? Data {
                
                do {
                    let updated_profile_data = try JSONDecoder().decode(PersonalDetailsModel.self, from: saved_new_data)
                    
                    self.setNewProfileValues(profile_model: updated_profile_data)
                    
                } catch(let err) {
                    UtilityManager().showToast(message: err.localizedDescription)
                }
            }
            
            if let deleted_new_data = UserDefaults.standard.value(forKey: UserDefaultsKey.new_deleted_profile_data) as? Data {
                
                do {
                    let updated_delete_data = try JSONDecoder().decode([ProfileDataModel].self, from: deleted_new_data)
                    
                    self.deleteNewData(arr_data_to_delete: updated_delete_data)
                    
                } catch(let err) {
                    UtilityManager().showToast(message: err.localizedDescription)
                }
            }
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.new_updated_profile_data)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.new_deleted_profile_data)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.auto_sync_api_status)
        }
    }
    
    
    func setNewProfileValues(profile_model: PersonalDetailsModel) {
        if let counry_code = UserDefaults.standard.value(forKey:UserDefaultsKey.country_code) as? String, let mobile_number = UserDefaults.standard.value(forKey:UserDefaultsKey.mobile_number) as? String
        {
            let isDataAdded = ProfileViewModel().saveLoggedUserPersonalDetails(userID: "\(counry_code) \(mobile_number)", profile_model: profile_model)
            
            if isDataAdded {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.new_updated_profile_data)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.auto_sync_api_status)
            }
            
            print("Is Personal details user data added - \(isDataAdded)")
        }
    }
    
    
    func deleteNewData(arr_data_to_delete : [ProfileDataModel]) {
        if arr_data_to_delete.count > 0 {
            arr_data_to_delete.forEach { model in
                
                let isDataDeleted = ProfileViewModel().deleteLoggedUserPersonalDetails(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", model: model)
                
                if isDataDeleted {
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.new_deleted_profile_data)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.auto_sync_api_status)
                }
                
                print("Is Personal details user data deleted - \(isDataDeleted)")
            }
        }
    }
}
