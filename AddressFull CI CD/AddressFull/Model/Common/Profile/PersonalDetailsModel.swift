//
//  PersonalDetailsModel.swift
//  AddressFull
//
//  Created by Sneh on 11/24/23.
//

import Foundation


struct PersonalDetailsModel : Codable {
    var first_name : ProfileDataModel
    var last_name : ProfileDataModel
    var image : Data?
    var arr_mobile_numbers : [ProfileDataModel]
    var arr_email : [ProfileDataModel]
    var arr_address : [ProfileDataModel]
    var arr_social_links : [ProfileDataModel]
}

struct ProfileDataModel : Codable {
    var field_id : String = ""
    var type_of_field : String
    var type_of_value : String
    var value : String
    var is_selected : Bool = false
    var country_code : String? = nil
}

