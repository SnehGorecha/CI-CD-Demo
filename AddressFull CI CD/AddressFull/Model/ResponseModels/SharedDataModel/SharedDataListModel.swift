//
//  SharedDataListModel.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation


struct SharedDataListModel : Codable {
    var id : String?
    var organization_profile_image : String?
    var organization_name : String?
    var shared_data_timestamp : String?
    var mobile_number, email_id , address : [Int]?
    var shared_social_data : SharedSocialDataModel?
    var tbl_height : CGFloat?
    var is_reload : Bool = true
    var shared_data_count : Int?
}


struct SharedDataModel : Codable {
    var type_of_value : String?
    var value : String?
}
