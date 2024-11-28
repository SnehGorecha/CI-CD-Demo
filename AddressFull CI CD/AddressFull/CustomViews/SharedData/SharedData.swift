//
//  SharedData.swift
//  AddressFull
//
//  Created by Sneh on 03/04/24.
//

import Foundation
import UIKit


class SharedData {
    
    // MARK: - SET SHARED DATA
    
    func setupStackViewData(stack_view_shared_details: UIStackView,
                            shared_data_list_model : SharedDataListModel,
                            user_profile_model : PersonalDetailsModel) {
        
        DispatchQueue.main.async {
            
            stack_view_shared_details.arrangedSubviews.forEach { view in
                stack_view_shared_details.removeArrangedSubview(view)
            }
            
            self.addFirstNameLastName(stack_view_shared_details: stack_view_shared_details)
            
            self.addMobileNumbers(stack_view_shared_details: stack_view_shared_details,
                                  shared_data_list_model: shared_data_list_model,
                                  user_profile_model: user_profile_model)
            
            self.addEmails(stack_view_shared_details: stack_view_shared_details,
                           shared_data_list_model: shared_data_list_model,
                           user_profile_model: user_profile_model)
            
            self.addAddress(stack_view_shared_details: stack_view_shared_details,
                            shared_data_list_model: shared_data_list_model,
                            user_profile_model: user_profile_model)
            
            self.addSocialLinks(stack_view_shared_details: stack_view_shared_details,
                                shared_data_list_model: shared_data_list_model)
        }
    }
    
    
    func addFirstNameLastName(stack_view_shared_details: UIStackView) {
        
        // ADD HEADER
        self.addHeaderView(stack_view_shared_details: stack_view_shared_details,
                           title: LocalText.Profile().name())
        
        // ADD FIRST NAME CELL
        let first_name_data_model = SharedDataModel(type_of_value: LocalText.Profile().first_name(),value: UserDetailsModel.shared.first_name)
        self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                              is_right_label_hidden: false,
                              shared_data_model: first_name_data_model)
        
        // ADD LAST NAME CELL
        let last_name_data_model = SharedDataModel(type_of_value: LocalText.Profile().last_name(),value: UserDetailsModel.shared.last_name)
        self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                              is_right_label_hidden: false,
                              shared_data_model: last_name_data_model)
    }
    
    func addMobileNumbers(stack_view_shared_details: UIStackView,
                          shared_data_list_model: SharedDataListModel,
                          user_profile_model : PersonalDetailsModel) {
        
        if shared_data_list_model.mobile_number?.count ?? 0 > 0 {
            
            // ADD HEADER
            self.addHeaderView(stack_view_shared_details: stack_view_shared_details,
                               title: LocalText.PersonalDetails().mobile_number())
            
            // ADD CELL
            for i in 0..<(shared_data_list_model.mobile_number?.count ?? 0) {
                if let shared_mobile_int = shared_data_list_model.mobile_number?[i],
                   user_profile_model.arr_mobile_numbers.count >= shared_mobile_int
                {
                    let shared_mobile_number = "\(user_profile_model.arr_mobile_numbers[shared_mobile_int - 1].country_code?.dialCode() ?? "") \(user_profile_model.arr_mobile_numbers[shared_mobile_int - 1].value)"
                    let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.SignUpScreen().mobile_number()) \(shared_mobile_int)",value: shared_mobile_number)
                    self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                                          is_right_label_hidden: false,
                                          shared_data_model: shared_data_model)
                }
            }
        }
    }
    
    func addEmails(stack_view_shared_details: UIStackView,
                   shared_data_list_model: SharedDataListModel,
                   user_profile_model : PersonalDetailsModel) {
        
        if shared_data_list_model.email_id?.count ?? 0 > 0 {
            
            // ADD HEADER
            self.addHeaderView(stack_view_shared_details: stack_view_shared_details,
                               title: LocalText.PersonalDetails().email())
            
            // ADD CELL
            for i in 0..<(shared_data_list_model.email_id?.count ?? 0) {
                if let shared_email_int = shared_data_list_model.email_id?[i], user_profile_model.arr_email.count >= shared_email_int
                {
                    let shared_email = user_profile_model.arr_email[shared_email_int - 1].value
                    let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.MyProfile().email()) \(shared_email_int)",value: shared_email)
                    self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                                          is_right_label_hidden: false,
                                          shared_data_model: shared_data_model)
                }
            }
        }
    }
    
    func addAddress(stack_view_shared_details: UIStackView,
                    shared_data_list_model: SharedDataListModel,
                    user_profile_model : PersonalDetailsModel) {
        
        if shared_data_list_model.address?.count ?? 0 > 0 {
            
            // ADD HEADER
            self.addHeaderView(stack_view_shared_details: stack_view_shared_details,
                               title: LocalText.PersonalDetails().address())
            
            // ADD CELL
            for i in 0..<(shared_data_list_model.address?.count ?? 0) {
                if let shared_address_int = shared_data_list_model.address?[i], user_profile_model.arr_address.count >= shared_address_int
                {
                    let shared_address = user_profile_model.arr_address[shared_address_int - 1].value
                    let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.MyProfile().address()) \(shared_address_int)",value: shared_address)
                    self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                                          is_right_label_hidden: true,
                                          shared_data_model: shared_data_model)
                }
            }
        }
    }
    
    func addSocialLinks(stack_view_shared_details: UIStackView,
                        shared_data_list_model: SharedDataListModel) {
        
        if shared_data_list_model.shared_social_data?.linkedin != "" || shared_data_list_model.shared_social_data?.twitter != ""
        {
            
            // ADD HEADER
            self.addHeaderView(stack_view_shared_details: stack_view_shared_details,
                               title: LocalText.MyProfile().social())
            
            // ADD CELL
            self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                                  is_right_label_hidden: nil,
                                  linked_in_hidden: shared_data_list_model.shared_social_data?.linkedin == "",
                                  twitter_hidden: shared_data_list_model.shared_social_data?.twitter == "",
                                  shared_data_model: nil)
        }
    }
    
    
    /// This function is used to add header view in stack view
    func addHeaderView(stack_view_shared_details: UIStackView,
                       title: String) {
        
        let model = SharedDataModel(type_of_value: title,
                                    value: "")
        
        self.addTableViewCell(stack_view_shared_details: stack_view_shared_details,
                              is_right_label_hidden: false,
                              shared_data_model: model,
                              is_for_header: true)
    }
    
    
    /// This function is used to add individual cell in stack view
    func addTableViewCell(stack_view_shared_details: UIStackView,
                          is_right_label_hidden: Bool?,
                          linked_in_hidden: Bool = true,
                          twitter_hidden: Bool = true,
                          shared_data_model: SharedDataModel?,
                          is_for_header: Bool = false) {
        
        DispatchQueue.main.async {
            
            let cell = Bundle.main.loadNibNamed(SharedDataDetailsTblViewCell.identifier, owner: UIApplication.topViewController(), options: nil)?.first as! SharedDataDetailsTblViewCell
            
            cell.setupUI(is_right_label_hidden: is_right_label_hidden)
            cell.setupData(shared_data_model: shared_data_model,
                           linked_in_hidden:linked_in_hidden,
                           twitter_hidden: twitter_hidden,
                           is_for_header: is_for_header)
            
            stack_view_shared_details.addArrangedSubview(cell)
        }
    }
    
}
