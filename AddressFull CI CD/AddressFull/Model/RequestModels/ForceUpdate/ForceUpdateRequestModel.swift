//
//  ForceUpdateRequestModel.swift
//  AddressFull
//
//  Created by Sneh on 08/10/24.
//


import Foundation


struct ForceUpdateRequestModel: Encodable {
        
    /// Objects
    let device_type: String
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case device_type
    }
}
