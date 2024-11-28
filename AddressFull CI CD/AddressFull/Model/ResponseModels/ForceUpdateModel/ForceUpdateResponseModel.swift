//
//  ForceUpdateResponseModel.swift
//  AddressFull
//
//  Created by Sneh on 08/10/24.
//

import Foundation

struct ForceUpdateResponseModel: Codable {
    
    var status  : Int?    = nil
    var message : String? = nil
    var data    : ForceUpdateResponseData?   = ForceUpdateResponseData()
    
    enum CodingKeys: String, CodingKey {
        
        case status  = "status"
        case message = "message"
        case data    = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status  = try values.decodeIfPresent(Int.self    , forKey: .status  )
        message = try values.decodeIfPresent(String.self , forKey: .message )
        data    = try values.decodeIfPresent(ForceUpdateResponseData.self   , forKey: .data    )
        
    }
    
    init() {
        
    }
    
}



struct ForceUpdateResponseData: Codable {
    
    var deviceType  : String? = nil
    var forceUpdate : Bool?   = nil
    
    enum CodingKeys: String, CodingKey {
        
        case deviceType  = "device_type"
        case forceUpdate = "force_update"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        deviceType  = try values.decodeIfPresent(String.self , forKey: .deviceType  )
        forceUpdate = try values.decodeIfPresent(Bool.self   , forKey: .forceUpdate )
        
    }
    
    init() {
        
    }
    
}
