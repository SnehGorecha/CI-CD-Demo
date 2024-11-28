//
//  RequestListResponseModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation


struct RequestListResponseModel: Codable {
    
    var request_id                 : String? = nil
    var organization_id            : String? = nil
    var organization_name          : String? = nil
    var organization_profile_image : String? = nil
    var request_date               : String? = nil
    var message                    : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case request_id                 = "request_id"
        case organization_id            = "organization_id"
        case organization_name          = "organization_name"
        case organization_profile_image = "organization_profile_image"
        case request_date               = "request_date"
        case message                    = "message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        request_id  = try values.decodeIfPresent(String.self , forKey: .request_id)
        organization_id  = try values.decodeIfPresent(String.self , forKey: .organization_id )
        organization_name  = try values.decodeIfPresent(String.self , forKey: .organization_name )
        organization_profile_image = try values.decodeIfPresent(String.self , forKey: .organization_profile_image )
        request_date  = try values.decodeIfPresent(String.self , forKey: .request_date )
        message  = try values.decodeIfPresent(String.self , forKey: .message )
        
    }
    
    init() {
        
    }
    
}
