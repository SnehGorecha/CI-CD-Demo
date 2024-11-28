//
//  RefreshTokenDataModel.swift
//  AddressFull
//
//  Created by Sneh on 11/04/24.
//

import Foundation


struct RefreshTokenDataModel: Codable {
    
    var token             : String? = nil
    
    enum CodingKeys: String, CodingKey {
        case token             = "token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token      = try values.decodeIfPresent(String.self , forKey: .token )
    }
    
    init() {
        
    }
    
}
