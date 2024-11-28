//
//  RequestListDataResponseModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation


struct RequestListDataResponseModel: Codable {
    
    var notification_list : [RequestListResponseModel]? = []
    var page_info         : RequestListPageInfoResponseModel? = RequestListPageInfoResponseModel()
    
    enum CodingKeys: String, CodingKey {
        case notification_list = "notification_list"
        case page_info         = "page_info"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        notification_list = try values.decodeIfPresent([RequestListResponseModel].self , forKey: .notification_list )
        page_info = try values.decodeIfPresent(RequestListPageInfoResponseModel.self, forKey: .page_info )
        
    }
    
    init() {
        
    }
    
}
