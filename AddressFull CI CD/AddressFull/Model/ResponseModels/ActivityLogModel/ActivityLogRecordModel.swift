//
//  ActivityLogRecordModel.swift
//  AddressFull
//
//  Created by Sneh on 12/01/24.
//

import Foundation


struct ActivityLogResultModel: Codable {
    
    var id                  : String?   = nil
    var organization_name   : String?   = nil
    var organization_logo   : String?   = nil
    var message             : String?   = nil
    var log_type            : String?   = nil
    var permission_status   : String?   = nil
    var country_code        : String?   = nil
    var email               : String?   = nil
    var mobile_number       : String?   = nil
    var created_date        : String?   = nil
    
    
    enum CodingKeys: String, CodingKey {
        
        case id                 = "id"
        case organization_name  = "organization_name"
        case organization_logo  = "organization_logo"
        case message            = "message"
        case log_type           = "log_type"
        case permission_status  = "permission_status"
        case country_code       = "country_code"
        case email              = "email"
        case mobile_number      = "mobile_number"
        case created_date       = "created_date"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id                  = try values.decodeIfPresent(String.self   , forKey: .id )
        organization_name   = try values.decodeIfPresent(String.self   , forKey: .organization_name )
        organization_logo   = try values.decodeIfPresent(String.self   , forKey: .organization_logo )
        message             = try values.decodeIfPresent(String.self   , forKey: .message )
        log_type            = try values.decodeIfPresent(String.self   , forKey: .log_type )
        permission_status   = try values.decodeIfPresent(String.self   , forKey: .permission_status )
        country_code        = try values.decodeIfPresent(String.self   , forKey: .country_code )
        email               = try values.decodeIfPresent(String.self   , forKey: .email )
        mobile_number       = try values.decodeIfPresent(String.self   , forKey: .mobile_number )
        created_date        = try values.decodeIfPresent(String.self   , forKey: .created_date  )
        
    }
    
    init() {
        
    }
    
}
