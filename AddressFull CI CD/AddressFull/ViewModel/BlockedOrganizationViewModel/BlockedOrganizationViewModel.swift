//
//  BlockOrganizationViewModel.swift
//  AddressFull
//
//  Created by Sneh on 05/01/24.
//

import Foundation
import UIKit


class BlockedOrganizationViewModel {
    
    // MARK: - BLOCKED ORGANIZATION LIST
    
    /// Use this function to get block organization list
    func getBlockedOrganizationApiCall(search: String,
                                currentPage: Int,
                                view_for_progress_indicator: UIView,
                                is_pull_to_refresh: Bool = false,
                                completionHandler: @escaping ((_ is_success: Bool, _ model : OrganizationListBaseModel?, _ error_message : String?) -> Void)) {
        
        
        AlamofireAPICallManager.shared.apiCall (
            OrganizationListBaseModel.self,
            to: .blocked_organization_list,
            with: APIParameters.blockedOrganization(search: search, timezone: TimeZone.current.identifier, page: currentPage),
            view_for_progress_indicator: view_for_progress_indicator,
            is_pull_to_refresh: is_pull_to_refresh,
            pass_param_in_url_with_question_mark: true)
        { 
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                EncryptionDecryption.decryptResponse(OrganizationListBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model,nil)
                    } else {
                        completionHandler(false,nil,errorMessage)
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model,nil)
            } else {
                completionHandler(false, nil,errorMessage)
            }
        }
    }
    
    
    // MARK: - UNBLOCK ORGANIZATION
    
    /// Use this function to unblock the organization
    func blockUnblockOrganizationApiCall(organization_id : String?,
                                         block: Bool,
                                         reason: String?,
                                         view_for_progress_indicator: UIView,
                                         completionHandler: @escaping ((_ is_success: Bool) -> Void)) {
        
        var request = ""
        
        let request_model = BlockUnblockRequestModel(organization_id: organization_id, 
                                                  block_status: block,
                                                  reason_for_block: reason)
        
        if let new_request = EncryptionDecryption.encryptRequest(request_model) {
            request = new_request
        }
        
        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall (
            SignupResponseModel.self,
            to: .block_unblock_organization,
            with: nil ,
            view_for_progress_indicator: view_for_progress_indicator,
            encryptedRequest: request)
        { isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(SignupResponseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true)
                        UtilityManager().showToast(message: model.message ?? "")
                        
                    } else {
                        completionHandler(false)
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true)
                UtilityManager().showToast(message: model.message ?? "")
                
            } else {
                completionHandler(false)
                UtilityManager().showToast(message: errorMessage ?? "")
                
            }
        }
    }
    
}
