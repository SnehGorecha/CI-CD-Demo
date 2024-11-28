//
//  SignUpViewModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import Foundation
import UIKit


class SignUpViewModel {
    
    
    /// Use this  function to validate signup data from sign up request model
    func validateSignup(requestModel: SignupRequestModel) -> ValidationResult {
        if requestModel.mobile_number.isBlank {
            return ValidationResult(is_success: false, str_error_message: ValidationMessage.please_enter_mobile_number())
        }
        else if requestModel.mobile_number.count < ValaidationLength().min_mobile_number || requestModel.mobile_number.count > ValaidationLength().max_mobile_number {
            
            return ValidationResult(is_success: false, str_error_message: "\(LocalText.SignUpScreen().mobile_number()) \(ValidationMessage.should_be_between_6_to_13_characters())")
            
        } else {
            return ValidationResult(is_success: true, str_error_message: "")
        }
    }
    
    
    /// Use this  function to send otp
    func sendOtpApiCall(signup_request_model : SignupRequestModel,
                        is_for_login: Bool,
                        view_for_progress_indicator: UIView,
                        completionHandler: @escaping((_ is_success: Bool, _ model: SignupResponseModel?) -> Void)) {
        
        
        if let public_key = KeyChain().load(key: KeyChainKey.public_key, group: KeyChainKey.group)?.toString() {
            
            // KEY EXCHANGE COMPLETION
            KeyExchange.completion = { is_success,error_message in
                
                // CALL SIGNUP OR LOGIN API
                if is_success {
                    
                    var request = ""
                    
                    if let new_request = EncryptionDecryption.encryptRequest(signup_request_model) {
                        request = new_request
                    }
                    
                    AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
                    
                    AlamofireAPICallManager.shared.apiCall(
                        SignupResponseModel.self,
                        to: is_for_login ? .login : .signup,
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
                                    completionHandler(false,newResponseModel)
                                }
                            }
                            
                        } else if let model = responseModel, isSuccess {
                            completionHandler(true,model)
                            
                        } else {
                            completionHandler(false,responseModel)
                        }
                    }
                    
                } else {
                    completionHandler(false,nil)
                    UtilityManager().showToast(message: error_message)
                }
            }
            
            // CALL KEY EXCHANGE API
            KeyExchange.callKeyExchangeApi(public_key: public_key,view_for_progress_indicator: view_for_progress_indicator)
            
        } else {
            KeyExchange.generatePublicAndPrivateRSAKeyPair(view_for_progress_indicator: view_for_progress_indicator,call_key_exchange_api: true)
        }
        
    }
}
