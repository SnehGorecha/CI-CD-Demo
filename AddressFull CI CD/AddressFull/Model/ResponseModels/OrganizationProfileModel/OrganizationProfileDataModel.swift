//
//  OrganizationProfileDataModel.swift
//  AddressFull
//
//  Created by Sneh on 12/19/23.
//

import Foundation


struct OrganizationProfileDataModel : Codable {
    
    let id: String?
    let organization_profile_image: String?
    let organization_name: String?
    let email_id, mobile_number, address : [String]?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case organization_profile_image = "organization_profile_image"
        case organization_name = "organization_name"
        case email_id = "email_id"
        case mobile_number = "mobile_number"
        case address = "address"

    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id)
        organization_profile_image = try values.decodeIfPresent(String.self, forKey: .organization_profile_image)
        organization_name = try values.decodeIfPresent(String.self, forKey: .organization_name)
        email_id = try values.decodeIfPresent([String].self, forKey: .email_id)
        mobile_number = try values.decodeIfPresent([String].self, forKey: .mobile_number)
        address = try values.decodeIfPresent([String].self, forKey: .address)
    }
}
