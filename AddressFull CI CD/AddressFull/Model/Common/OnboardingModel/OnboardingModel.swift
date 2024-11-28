//
//  OnboardingModel.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import Foundation


struct OnboardingModel {
    
    var current_index: Int = 0
    var image: String
    var title: String
    var description: String
    var first_button_title: String?
    var last_button_title: String
    var is_next_redirection_enabled: Bool = true
    var segment_image: String?
}
