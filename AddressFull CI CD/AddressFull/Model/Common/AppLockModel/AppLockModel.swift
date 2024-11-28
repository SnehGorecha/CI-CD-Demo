//
//  AppLockModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 07/11/23.
//

import Foundation


struct AppLockModel {
    var header_title = ""
    var options = [AppLockModelDelay]()
}

struct AppLockBaseModel {
    var model = [AppLockModel]()
}


struct AppLockModelDelay {
    var is_selected = false
    var option = ""
}
