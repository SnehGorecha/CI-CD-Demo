//
//  NotificationViewModel.swift
//  AddressFull
//
//  Created by Sneh on 12/01/24.
//

import Foundation
import UIKit


class NotificationViewModel {
    
    /// Use this function to call read notification API
    func readNotificationApiCall(id: String,
                          view_for_progress_indicator: UIView,
                          completion: (@escaping() -> Void)) {
        
        AlamofireAPICallManager.shared.apiCall (
            SignupResponseModel.self,
            to: .my_trusted_organization,
            with: APIParameters.readNotification(id: id),
            view_for_progress_indicator: view_for_progress_indicator,
            pass_param_in_url_with_question_mark: true)
        { 
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                EncryptionDecryption.decryptResponse(SignupResponseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    
                    if let model = newResponseModel, isSuccess {
                        UtilityManager().showToast(message: model.message ?? "")
                        completion()
                        
                    } else {
                        UtilityManager().showToast(message: errorMessage ?? "")
                    }
                }
            } else if let model = responseModel, isSuccess {
                UtilityManager().showToast(message: model.message ?? "")
                completion()
                
            } else {
                UtilityManager().showToast(message: errorMessage ?? "")
            }
        }
    }
    
}
