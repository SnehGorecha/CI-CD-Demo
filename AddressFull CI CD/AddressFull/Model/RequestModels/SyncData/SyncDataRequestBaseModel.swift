//
//  SyncDataRequestBaseModel.swift
//  AddressFull
//
//  Created by Sneh on 01/02/24.
//

import Foundation


struct SyncDataRequestBaseModel: Encodable {
    
    
    /// Objects
    var shared_data: [SyncDataRequestModel]?
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case shared_data
    }
}
