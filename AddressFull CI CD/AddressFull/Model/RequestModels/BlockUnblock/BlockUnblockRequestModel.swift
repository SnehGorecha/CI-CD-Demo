//
//  BlockUnblockRequestModel.swift
//  AddressFull
//
//  Created by Sneh on 12/03/24.
//

import Foundation

struct BlockUnblockRequestModel: Encodable {
    
    
    /// Objects
    var organization_id: String?
    var block_status: Bool
    var reason_for_block: String?
    
    
    /// To serialize objects this enum will be used
    enum CodingKeys: String, CodingKey {
        case organization_id
        case block_status
        case reason_for_block
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode organization_id if it's not nil
        if let organization_id = organization_id {
            try container.encode(organization_id, forKey: .organization_id)
        }
        
        // Encode block_status as a string "true" or "false"
        try container.encode(block_status, forKey: .block_status)
        
        // Encode reason_for_block if it's not nil
        if let reason_for_block = reason_for_block {
            try container.encode(reason_for_block, forKey: .reason_for_block)
        }
    }
}
