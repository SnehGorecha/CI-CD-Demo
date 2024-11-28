//
//  OrganizationProfileViewModel.swift
//  AddressFull
//
//  Created by Sneh on 02/01/24.
//

import Foundation
import UIKit


class OrganizationProfileViewModel {
    
    // MARK: - ORGANIZATION PROFILE
    
    /// Use this function to organization profile
    func getOrganizationProfileApiCall(id: String,
                                view_for_progress_indicator: UIView?,
                                completionHandler: @escaping ((_ is_success: Bool, _ model : OrganizationProfileModel?) -> Void)) {
         
        AlamofireAPICallManager.shared.apiCall (
            OrganizationProfileModel.self,
            to: .organization_profile,
            with: APIParameters.organizationProfile(timezone: TimeZone.current.identifier),
            view_for_progress_indicator: view_for_progress_indicator,
            pass_param_in_url_with_question_mark: true,
            organization_id: id)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(OrganizationProfileModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        completionHandler(false,nil)
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model)
                
            } else {
                completionHandler(false, nil)
                UtilityManager().showToast(message: errorMessage ?? "")
                
            }
        }
    }
    
    
    // MARK: - DELETE ORGANIZATION
    
    /// Use this function to delete organization
    func deleteMyTrustedOrganizationApiCall(id: String,
                                     view_for_progress_indicator: UIView,
                                     completionHandler: @escaping ((_ is_success: Bool, _ model : SignupResponseModel?) -> Void)) {
        
        AlamofireAPICallManager.shared.apiCall(
            SignupResponseModel.self,
            to: .delete_my_trusted_organization,
            with: APIParameters.deleteOrganization(id: id),
            view_for_progress_indicator: view_for_progress_indicator,
            pass_param_in_url_with_question_mark: false)
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
    
    
    // MARK: - SHARE DATA TO ORGANIZATION
    
    /// Use this function to share data to organization
    func shareDataToOrganizationApiCall(share_data_request_model : ShareDataRequestBaseModel,
                                 view_for_progress_indicator: UIView,
                                 completionHandler: @escaping((_ is_success: Bool, _ model: SignupResponseModel?) -> Void)) {
        
        var request = ""
        
        if let new_request = EncryptionDecryption.encryptRequest(share_data_request_model) {
            request = new_request
        }

        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall(
            SignupResponseModel.self,
            to: .share_data,
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
                        UtilityManager().showToast(message: model.message ?? "")
                        
                    } else {
                        completionHandler(false,nil)
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
                
            } else if let model = responseModel, isSuccess {
                completionHandler(true,model)
                UtilityManager().showToast(message: model.message ?? "")
                
            }
            else {
                completionHandler(false,nil)
                UtilityManager().showToast(message: errorMessage ?? "")
                
            }
        }
    }
}
