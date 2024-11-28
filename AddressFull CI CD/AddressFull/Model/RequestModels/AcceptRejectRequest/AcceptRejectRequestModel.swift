//
//  AcceptRejectRequestModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation


struct AcceptRejectRequestModel: Encodable {
    
    /// Objects
    let request_id: String
    let organization_id: String
    let request_status: Bool
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case request_id
        case organization_id
        case request_status
    }
}
