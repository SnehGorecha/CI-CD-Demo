//
//  SettingsViewModel.swift
//  AddressFull
//
//  Created by Sneh on 17/01/24.
//

import Foundation
import Alamofire

class SettingsViewModel {
    
    
    /// Use this function to delete user account or delete all trusted organizations of  user
    func deleteApiCall(_ type: SettingDeleteType, view_for_progress_indicator: UIView, completionHandler: @escaping((_ is_success: Bool, _ model: SignupResponseModel?) -> Void)) {

        AlamofireAPICallManager.shared.apiCall(
            SignupResponseModel.self,
            to: (type == .my_profile) ? .delete_my_account : .delete_all_trusted_organization,
            with: (type == .my_profile) ? APIParameters.deleteAccountOrTrustedOrganizations() : nil,
            view_for_progress_indicator: view_for_progress_indicator,
            pass_param_in_url_with_question_mark: (type == .my_profile) ? false : nil) 
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
    
}
