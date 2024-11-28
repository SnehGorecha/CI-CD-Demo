//
//  ResendOTPRequestModel.swift
//  AddressFull
//
//  Created by Sneh on 11/25/23.
//

import Foundation


struct ResendOTPRequestModel: Encodable {
    
    
    /// Objects
    let country_code: String
    let mobile_number: String
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case country_code
        case mobile_number
    }
}
