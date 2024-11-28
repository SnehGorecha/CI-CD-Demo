//
//  ActivityFilterDataModel.swift
//  AddressFull
//
//  Created by Sneh on 11/04/24.
//

import Foundation


struct ActivityFilterDataModel: Codable {
    
    var title             : String? = nil
    var start_date        : String? = nil
    var end_date          : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case title              = "title"
        case start_date         = "start_date"
        case end_date           = "end_date"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title             = try values.decodeIfPresent(String.self , forKey: .title )
        start_date        = try values.decodeIfPresent(String.self , forKey: .start_date )
        end_date          = try values.decodeIfPresent(String.self , forKey: .end_date )
        
    }
    
    init(title: String? = nil, start_date: String? = nil, end_date: String? = nil) {
        self.title = title
        self.start_date = start_date
        self.end_date = end_date
    }
    
}
