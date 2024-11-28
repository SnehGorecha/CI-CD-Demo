//
//  SignupOTPModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 20/11/23.
//

import Foundation


struct SignupOTPRequestModel: Encodable {
    
    
    /// Objects
    let country_code: String
    let mobile_number: String
    let otp: String
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case country_code
        case mobile_number
        case otp
    }
}
