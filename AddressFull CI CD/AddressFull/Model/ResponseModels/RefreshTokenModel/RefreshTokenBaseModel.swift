//
//  RefreshTokenBaseModel.swift
//  AddressFull
//
//  Created by Sneh on 11/04/24.
//

import Foundation


struct RefreshTokenBaseModel: Codable {
    
    var status : Int?  = nil
    var data   : RefreshTokenDataModel? = RefreshTokenDataModel()
    var message   : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data   = "data"
        case message    = "message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decodeIfPresent(Int.self  , forKey: .status )
        data   = try values.decodeIfPresent(RefreshTokenDataModel.self , forKey: .data   )
        message   = try values.decodeIfPresent(String.self , forKey: .message)
        
    }
    
    init() {
        
    }
    
}
