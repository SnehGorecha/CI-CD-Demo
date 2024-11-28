//
//  ActivityLogDataModel.swift
//  AddressFull
//
//  Created by Sneh on 12/01/24.
//

import Foundation


struct ActivityLogDataModel: Codable {

  var results             : [ActivityLogResultModel]? = []
  var fetched_records_count : Int?       = nil
  var bookmark            : String?    = nil

  enum CodingKeys: String, CodingKey {

    case results             = "results"
    case fetched_records_count = "fetchedRecordsCount"
    case bookmark            = "bookmark"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    results             = try values.decodeIfPresent([ActivityLogResultModel].self , forKey: .results )
    fetched_records_count = try values.decodeIfPresent(Int.self       , forKey: .fetched_records_count )
    bookmark            = try values.decodeIfPresent(String.self    , forKey: .bookmark )
 
  }

  init() {

  }

}
