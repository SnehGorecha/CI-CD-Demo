//
//  HomeViewModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 27/11/23.
//

import Foundation
import Alamofire

class HomeViewModel {
    
    /// Use this function to get my trusted organization list
    func getMyTrustedOrganizationApiCall(search: String,
                                         currentPage: Int,
                                         page_size: Int = 10,
                                         view_for_progress_indicator: UIView,
                                         is_pull_to_refresh: Bool = false,
                                         completionHandler: @escaping ((_ is_success: Bool, _ model : OrganizationListBaseModel?, _ search_active: Bool) -> Void)) {
        
        
        AlamofireAPICallManager.shared.apiCall (
            OrganizationListBaseModel.self,
            to: .my_trusted_organization,
            with: APIParameters.myTrustedOrganization(search: search, page: currentPage,page_size : page_size,timezone: TimeZone.current.identifier),
            view_for_progress_indicator: view_for_progress_indicator,
            is_pull_to_refresh: is_pull_to_refresh,
            pass_param_in_url_with_question_mark: true)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(OrganizationListBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model,false)
                        
                    } else {
                        
                        completionHandler(false,nil,false)
                        UtilityManager().showToast(message: errorMessage ?? "")
                        
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model,false)
                
            } else {
                completionHandler(false, nil,false)
                UtilityManager().showToast(message: errorMessage ?? "")
            }
        }
    }
    
    /// Use this function to download shared data report
    func downloadSharedDataReportApiCall(view_for_progress_indicator: UIView,
                                         completionHandler: @escaping ((_ is_success: Bool, _ model : SharedDataReportResponseBaseModel?) -> Void)) {
        
        
        AlamofireAPICallManager.shared.apiCall (
            SharedDataReportResponseBaseModel.self,
            to: .shared_data_report,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(SharedDataReportResponseBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
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
    
    
}

