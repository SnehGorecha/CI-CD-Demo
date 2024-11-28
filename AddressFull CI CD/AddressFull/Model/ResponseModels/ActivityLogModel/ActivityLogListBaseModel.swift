//
//  ActivityLogListBaseModel.swift
//  AddressFull
//
//  Created by Sneh on 12/01/24.
//

import Foundation


struct ActivityLogListBaseModel: Codable {
    
    var status : Int?  = nil
    var data   : ActivityLogDataModel? = ActivityLogDataModel()
    var message   : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data   = "data"
        case message    = "message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decodeIfPresent(Int.self  , forKey: .status )
        data   = try values.decodeIfPresent(ActivityLogDataModel.self , forKey: .data   )
        message   = try values.decodeIfPresent(String.self , forKey: .message)
        
    }
    
    init() {
        
    }
    
}
