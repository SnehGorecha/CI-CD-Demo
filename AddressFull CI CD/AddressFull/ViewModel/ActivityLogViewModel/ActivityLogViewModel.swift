//
//  ActivityLogViewModel.swift
//  AddressFull
//
//  Created by Sneh on 12/01/24.
//

import Foundation
import Alamofire

class ActivityLogViewModel {
    
    /// Use this function to get request list from organizations
    func getActivityLogListApiCall(book_mark: String?,
                                   start_date: String,
                                   end_date: String,
                                   sort_order: String,
                                   view_for_progress_indicator: UIView,
                                   is_pull_to_refresh: Bool = false,
                                   completionHandler: @escaping ((_ is_success: Bool, _ model : ActivityLogListBaseModel?) -> Void)) {
                        
        AlamofireAPICallManager.shared.apiCall (
            ActivityLogListBaseModel.self,
            to: .activity_log_list,
            with: APIParameters.activityList(book_mark: book_mark,
                                             timezone: TimeZone.current.identifier,
                                             start_date: start_date,
                                             end_date: end_date,
                                             sort_order: sort_order),
            view_for_progress_indicator: view_for_progress_indicator,
            is_pull_to_refresh: is_pull_to_refresh,
            pass_param_in_url_with_question_mark: true)
        { 
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                EncryptionDecryption.decryptResponse(ActivityLogListBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        
                        if errorMessage != AFError.explicitlyCancelled.errorDescription {
                            UtilityManager().showToast(message: errorMessage ?? "")
                        }
                        
                        completionHandler(false,nil)
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model)
                
            } else {
                
                if errorMessage != AFError.explicitlyCancelled.errorDescription {
                    UtilityManager().showToast(message: errorMessage ?? "")
                }
                
                completionHandler(false, nil)
            }
        }
    }
    
    
    /// Use this function to get filters list
    func getFilterListApiCall(view_for_progress_indicator: UIView,
                              completionHandler: @escaping ((_ is_success: Bool, _ model : ActivityFilterBaseModel?) -> Void)) {
                        
        AlamofireAPICallManager.shared.apiCall (
            ActivityFilterBaseModel.self,
            to: .activity_filters,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                EncryptionDecryption.decryptResponse(ActivityFilterBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        
                        if errorMessage != AFError.explicitlyCancelled.errorDescription {
                            UtilityManager().showToast(message: errorMessage ?? "")
                        }
                        
                        completionHandler(false,nil)
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model)
                
            } else {
                
                if errorMessage != AFError.explicitlyCancelled.errorDescription {
                    UtilityManager().showToast(message: errorMessage ?? "")
                }
                
                completionHandler(false, nil)
            }
        }
    }
}
