//
//  SharedDataListDataModel.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation


struct SharedDataListDataModel : Codable {

    let shared_data_list : [SharedDataListModel]?

    enum CodingKeys: String, CodingKey {
        case shared_data_list = "shared_data_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shared_data_list = try values.decodeIfPresent([SharedDataListModel].self, forKey: .shared_data_list)
    }
}
