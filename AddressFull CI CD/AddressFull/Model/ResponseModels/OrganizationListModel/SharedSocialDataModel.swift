//
//  SharedSocialDataModel.swift
//  AddressFull
//
//  Created by Sneh on 09/01/24.
//

import Foundation


struct SharedSocialDataModel: Codable {
    
    var linkedin: String?
    var twitter: String?
    
    enum CodingKeys: String, CodingKey {
        case linkedin = "linkedin"
        case twitter = "twitter"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        linkedin = try values.decodeIfPresent(String.self, forKey: .linkedin)
        twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
    }
    
    init()  {
    }
}
