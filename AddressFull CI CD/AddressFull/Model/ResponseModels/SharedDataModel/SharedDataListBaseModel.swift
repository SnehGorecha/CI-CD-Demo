//
//  SharedDataListBaseModel.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation

struct SharedDataListBaseModel : Codable {
    
    let status : Int?
    let data : SharedDataListDataModel?
    var message   : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case message    = "message"
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent(SharedDataListDataModel.self, forKey: .data)
        message   = try values.decodeIfPresent(String.self , forKey: .message)
    }

}
