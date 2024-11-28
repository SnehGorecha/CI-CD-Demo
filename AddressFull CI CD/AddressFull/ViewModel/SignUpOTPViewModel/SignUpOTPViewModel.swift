//
//  SignUpOTPViewModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 20/11/23.
//

import Foundation
import CoreData
import UIKit


class SignUpOTPViewModel {
    
    
    /// Use this  function to validate signup otp data from sign up otp request model
    func validate(requestModel: SignupOTPRequestModel) -> ValidationResult {
        if requestModel.otp.isBlank {
            return ValidationResult(is_success: false, str_error_message: ValidationMessage.please_enter_otp())
        }
        if requestModel.otp.count < ValaidationLength().otp {
            return ValidationResult(is_success: false, str_error_message: ValidationMessage.please_enter_valid_otp())
        }
        else {
            return ValidationResult(is_success: true, str_error_message: "")
        }
    }
    
    
    
    /// Use this  function to delete token from local database after logout
    func deleteTokenAfterLogout() -> Bool {
        let data = [
            CoreDataBase.Entity.LoggedUserDetails.Fields.token : "",
        ] as [String : Any]
        
        return CoreDataManager.update(data: data,
                                      withPrediction: [CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : UserDetailsModel.shared.mobile_number,
                                                       CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : UserDetailsModel.shared.country_code],
                                      forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
    }
    
    
    /// Use this  function to submit and verify otp
    func submitOtpApiCall(has_entered_otp: Bool,
                          country_code: String,
                          country_iso_code: String,
                          mobile_number: String,
                          otp: String,
                          view_for_progress_indicator : UIView,
                          completionHandler: @escaping ((_ is_success: Bool, _ model : SignupResponseBaseModel?) -> Void)) {
        
        let request_model = SignupOTPRequestModel(country_code: country_code.removePlusFromBegin(), mobile_number: mobile_number, otp: otp)
        
        let validation = SignUpOTPViewModel().validate(requestModel: request_model)
        
        var request = ""
        
        if let new_request = EncryptionDecryption.encryptRequest(request_model) {
            request = new_request
        }
        
        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        if has_entered_otp, validation.is_success {
            
            AlamofireAPICallManager.shared.apiCall(
                SignupResponseBaseModel.self,
                to: .verify_otp,
                with: nil,
                view_for_progress_indicator: view_for_progress_indicator,
                encryptedRequest: request)
            { 
                isSuccess, responseModel, errorMessage, encryptedResponse in
                
                if let encryptedResponse = encryptedResponse {
                    
                    EncryptionDecryption.decryptResponse(SignupResponseBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                        
                        if let model = responseModel, isSuccess {
                            completionHandler(true,model)
                            UtilityManager().showToast(message: model.message ?? "")
                            
                        } else {
                            completionHandler(false,nil)
                            UtilityManager().showToast(message: errorMessage ?? "")
                        }
                    }
                }
                else if let model = responseModel, isSuccess {
                    
                    if let token = model.data?.token {
                        
                        let predection = [CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : mobile_number,
                                          CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : country_iso_code]
                        
                        let retrive_data = CoreDataManager.retriveData(withPrediction: predection, forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
                        
                        if retrive_data.0, let fetched = retrive_data.1 as? [NSManagedObject] , !fetched.isEmpty {
                            
                            let data = [CoreDataBase.Entity.LoggedUserDetails.Fields.token : token]
                            
                            let is_existing_same_user_details_updated = CoreDataManager.update(data:data,
                                                                                               withPrediction: predection,
                                                                                               forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
                            
                            print("is_existing_same_user_details_updated - \(is_existing_same_user_details_updated)")
                        } else {
                            let is_user_data_saved = ProfileViewModel().saveLoggedUserDetails(countryCode: country_iso_code, mobileNumber: mobile_number, token: token)
                            print("is_user_data_saved - \(is_user_data_saved)")
                            
                        }
                        
                        completionHandler(true, model)
                        UtilityManager().showToast(message: model.message ?? "")
                    }
                    else {
                        completionHandler(false, nil)
                        UtilityManager().showToast(message: errorMessage ?? "")
                    }
                } else {
                    completionHandler(false, nil)
                    UtilityManager().showToast(message: errorMessage ?? "")
                }
            }
        } else {
            completionHandler(false, nil)
            UtilityManager().showToast(message: validation.str_error_message ?? "")
        }
    }
    
    
    /// Use this  function to resend otp
    func resendOtpApiCall(country_code: String,
                          mobile_number: String,
                          view_for_progress_indicator: UIView) {
        
        let request_model = ResendOTPRequestModel(country_code: country_code, mobile_number: mobile_number)
        
        var request = ""
        
        if let new_request = EncryptionDecryption.encryptRequest(request_model) {
            request = new_request
        }
        
        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall(
            SignupResponseBaseModel.self,
            to: .resend_otp,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator,
            encryptedRequest: request)
        { isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(SignupResponseBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = responseModel, isSuccess {
                        UtilityManager().showToast(message: model.message ?? "")
                        
                    } else {
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
                
            } else if let model = responseModel, isSuccess {
                UtilityManager().showToast(message: model.message ?? "")
                
            } else {
                UtilityManager().showToast(message: errorMessage ?? "")
                
            }
        }
    }
}
