//
//  UserDetailsModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 28/11/23.
//

import Foundation


class UserDetailsModel {
    var country_code = ""
    var mobile_number = ""
    var token = ""
    var first_name = ""
    var last_name = ""
    var image = Data()
    
    static var shared = UserDetailsModel()
    
    init() {}
}
