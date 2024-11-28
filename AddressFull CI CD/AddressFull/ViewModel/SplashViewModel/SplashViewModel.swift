//
//  SplashViewModel.swift
//  AddressFull
//
//  Created by Sneh on 11/04/24.
//

import Foundation
import UIKit


class SplashViewModel {
    
    /// Use this function to refresh authorization token
    func refreshTokenApiCall(view_for_progress_indicator: UIView,
                            completionHandler: @escaping ((_ is_success: Bool, _ model : RefreshTokenBaseModel?) -> Void)) {
        
        
        AlamofireAPICallManager.shared.apiCall (
            RefreshTokenBaseModel.self,
            to: .refresh_token,
            with: nil,
            view_for_progress_indicator: view_for_progress_indicator)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                
                EncryptionDecryption.decryptResponse(RefreshTokenBaseModel.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    if let model = newResponseModel, isSuccess {
                        completionHandler(true,model)
                        
                    } else {
                        completionHandler(false,nil)
                    }
                }
            } else if let model = responseModel, isSuccess {
                completionHandler(true, model)
                
            } else {
                completionHandler(false, nil)
            }
        }
    }
}
