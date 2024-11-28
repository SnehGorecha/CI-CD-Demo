//
//  MyAcountModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import Foundation


struct MyAcountModel {
    
    var image = ""
    var name = ""
    var mobile_number = ""
    var email_id = ""
    var other_details = [MyAccountOtherDetailsModel]()
    var two_step_verification_base = MyAccountTowStepVerificartionQuestionBaseModel()
    
}


struct MyAccountOtherDetailsModel {
    var content = ""
    var placeholder_title = ""
    var is_mobile_number = false
    var is_drop_down_selection = false
}

struct MyAccountTowStepVerificartionQuestionBaseModel {
    var header_title = ""
    var two_step_verification = [MyAccountTowStepVerificartionQuestionModel]()
}

struct MyAccountTowStepVerificartionQuestionModel {
    var question = ""
    var answer = ""
    var is_selected = false
}
