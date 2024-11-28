//
//  SyncDataRequestModel.swift
//  AddressFull
//
//  Created by Sneh on 22/01/24.
//

import Foundation


struct SyncDataRequestModel: Encodable {
    
    
    /// Objects
    var type: String?
    var value: String?
    var old_value: String?
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case old_value
    }
}
