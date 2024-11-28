//
//  AppDelegateViewModel.swift
//  AddressFull
//
//  Created by Sneh on 08/10/24.
//

import Foundation
import UIKit

class AppDelegateViewModel {
    
    func forceUpdateApiCall(completionHandler: @escaping((_ is_success: Bool, _ model: ForceUpdateResponseData?) -> Void)) {
//        AlamofireAPICallManager.shared.header = ["Content-Type":"application/base64"]
        
        AlamofireAPICallManager.shared.apiCall(
            ForceUpdateResponseData.self,
            to: .force_update,
            with: ["device_type" : "IOS"],
            view_for_progress_indicator: nil,
            encryptedRequest: nil)
        {
            isSuccess, responseModel, errorMessage, encryptedResponse in
            
            if let encryptedResponse = encryptedResponse {
                                
                EncryptionDecryption.decryptResponse(ForceUpdateResponseData.self, response: encryptedResponse) { isSuccess, newResponseModel, errorMessage in
                    
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
        
    }
}
