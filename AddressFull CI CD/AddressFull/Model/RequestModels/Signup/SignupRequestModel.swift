//
//  SignupRequestModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import Foundation


struct SignupRequestModel: Encodable {
    
    
    /// Objects
    let country_code: String
    let mobile_number: String
    let device_id: String
    let device_token: String
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case country_code
        case mobile_number
        case device_id
        case device_token
    }
}
