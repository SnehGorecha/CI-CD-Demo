//
//  RequestListPageInfoResponseModel.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import Foundation


struct RequestListPageInfoResponseModel: Codable {

  var total_count  : Int? = nil
  var total_pages  : Int? = nil
  var current_page : Int? = nil

  enum CodingKeys: String, CodingKey {

    case total_count  = "total_count"
    case total_pages  = "total_pages"
    case current_page = "current_page"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

      total_count  = try values.decodeIfPresent(Int.self , forKey: .total_count  )
      total_pages  = try values.decodeIfPresent(Int.self , forKey: .total_pages  )
      current_page = try values.decodeIfPresent(Int.self , forKey: .current_page )
 
  }

  init() {

  }

}