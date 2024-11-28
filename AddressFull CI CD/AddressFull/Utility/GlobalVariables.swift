//
//  GlobalVariables.swift
//  AddressFull
//
//  Created by Sneh on 12/13/23.
//

import Foundation
import UIKit


class GlobalVariables {

    var is_app_launched = false
    var asked_for_password = false
    var device_id = ""
    var fcm_token = ""
    var vc_from_notification : UIViewController?
    var sync_data_completed = true
    var popup_showed = false
    var opened_keyboard_for_validation = false
    
    static var shared = GlobalVariables()
    
    init() {}
}
