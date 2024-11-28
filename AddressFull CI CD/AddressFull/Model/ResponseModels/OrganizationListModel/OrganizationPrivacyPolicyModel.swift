//
//  OrganizationPrivacyPolicyModel.swift
//  AddressFull
//
//  Created by Sneh on 06/03/24.
//

import Foundation

struct OrganizationPrivacyPolicyModel: Codable {
    
    var rule: String?
    var sub_rules: [String]?
    
    enum CodingKeys: String, CodingKey {
        case rule = "rule"
        case sub_rules = "sub_rules"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        rule = try values.decodeIfPresent(String.self, forKey: .rule)
        sub_rules = try values.decodeIfPresent([String].self, forKey: .sub_rules)
    }
    
    init()  {
    }
}
