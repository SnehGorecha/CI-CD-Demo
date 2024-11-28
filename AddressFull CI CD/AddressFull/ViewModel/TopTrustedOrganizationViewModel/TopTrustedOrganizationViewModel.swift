//
//  TopTrustedOrganizationViewModel.swift
//  AddressFull
//
//  Created by Sneh on 02/01/24.
//

import Foundation
import CoreLocation
import UIKit

class TopTrustedOrganizationViewModel {
        
    /// Use this function to get top trusted organization list
    func getTopTrustedOrganizationApiCall(search: String,
                                          currentPage: Int,
                                          view_for_progress_indicator: UIView,
                                          is_pull_to_refresh: Bool = false,
                                          completionHandler: @escaping ((_ is_success: Bool, _ model : OrganizationListBaseModel?) -> Void)) {
        
        AlamofireAPICallManager.shared.apiCall (
            OrganizationListBaseModel.self,
            to: .top_trusted_organization,
            with: APIParameters.topTrustedOrganization(search: search, page: currentPage),
            view_for_progress_indicator: view_for_progress_indicator,
            is_pull_to_refresh: is_pull_to_refresh,
            pass_param_in_url_with_question_mark: true)
        { 
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(OrganizationListBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
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
