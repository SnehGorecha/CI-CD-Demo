//
//  RequestListBaseReponseModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation


struct RequestListBaseReponseModel: Codable {
    
    var status : Int?  = nil
    var data   : RequestListDataResponseModel? = RequestListDataResponseModel()
    var message   : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data   = "data"
        case message    = "message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self  , forKey: .status)
        data   = try values.decodeIfPresent(RequestListDataResponseModel.self , forKey: .data )
        message   = try values.decodeIfPresent(String.self , forKey: .message)
        
    }
    
    init() {
        
    }
    
}
