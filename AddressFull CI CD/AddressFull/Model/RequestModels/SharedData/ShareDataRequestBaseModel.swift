//
//  ShareDataRequestBaseModel.swift
//  AddressFull
//
//  Created by Sneh on 04/03/24.
//

import Foundation


struct ShareDataRequestBaseModel: Encodable {
    
    
    /// Objects
    var organization_id: String?
    var shared_data: [SyncDataRequestModel]?
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case organization_id
        case shared_data
    }
}
