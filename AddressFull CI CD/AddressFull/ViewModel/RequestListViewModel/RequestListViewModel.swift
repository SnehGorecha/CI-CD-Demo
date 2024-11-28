//
//  RequestListViewModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation
import Alamofire


class RequestListViewModel {
    
    // MARK: - REQUESTS LIST
    
    /// Use this function to get request list from organizations
    func getRequestListApiCall(request_period: Int,
                        currentPage: Int,
                        view_for_progress_indicator: UIView,
                        is_pull_to_refresh: Bool = false,
                        completionHandler: @escaping ((_ is_success: Bool, _ model : RequestListBaseReponseModel?) -> Void)) {
        
         
        AlamofireAPICallManager.shared.apiCall (
            RequestListBaseReponseModel.self,
            to: .request_list,
            with: APIParameters.requestList(page: currentPage, timezone: TimeZone.current.identifier, request_period: request_period),
            view_for_progress_indicator: view_for_progress_indicator,
            is_pull_to_refresh: is_pull_to_refresh,
            pass_param_in_url_with_question_mark: true)
        { 
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(RequestListBaseReponseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        completionHandler(false,nil)
                        
                        if errorMessage != AFError.explicitlyCancelled.errorDescription {
                            UtilityManager().showToast(message: errorMessage ?? "")
                        }
                        
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model)
                
            } else {
                completionHandler(false, nil)
                
                if errorMessage != AFError.explicitlyCancelled.errorDescription {
                    UtilityManager().showToast(message: errorMessage ?? "")
                }
                
            }
        }
    }
    
    
    // MARK: - ACCEPT OR REJECT REQUEST
    
    /// Use this function to accept or reject request from organization
    func acceptRejectRequestApiCall(accept_reject_request_model : AcceptRejectRequestModel,
                             view_for_progress_indicator: UIView,
                             completionHandler: @escaping((_ is_success: Bool, _ model: SignupResponseModel?) -> Void)) {
        
        var request = ""
        
        if let new_request = EncryptionDecryption.encryptRequest(accept_reject_request_model) {
            request = new_request
        }
 
        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall(
            SignupResponseModel.self,
            to: .accept_reject_request,
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

