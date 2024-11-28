//
//  OrganizationProfileUserDetailsTblView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class OrganizationProfileUserDetailsTblView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_organization_profile_user_details_tbl_view_cell = OrganizationProfileUserDetailsTblViewCell.identifier
    let k_my_profile_input_field_tbl_view_cell = MyProfileInputFieldTblViewCell.identifier
    let k_single_button_tbl_view_cell = SingleButtonTblViewCell.identifier
    let k_organization_profile_principle_tbl_view_cell = OrganizationProfilePrincipleTblViewCell.identifier
    
    
    let section_title = [
        "",
        LocalText.Profile().first_name(),
        LocalText.Profile().last_name(),
        LocalText.SignUpScreen().mobile_number(),
        LocalText.MyProfile().email(),
        LocalText.MyProfile().address(),
        LocalText.MyProfile().social(),
        "",
        ""
    ]
    
    var drop_down_titles = [
        [""],
        [""],
        [""],
        [LocalText.PersonalDetails().primary(),LocalText.PersonalDetails().work(),LocalText.PersonalDetails().home()],
        [LocalText.PersonalDetails().primary(),LocalText.PersonalDetails().work()],
        [LocalText.PersonalDetails().home(),LocalText.Address().work()]
    ]
    
    var my_profile_model : PersonalDetailsModel = PersonalDetailsModel(first_name: ProfileDataModel(
        type_of_field: LocalText.Profile().first_name(),
        type_of_value: LocalText.Profile().first_name(),
        value: ""),
                                                                       last_name: ProfileDataModel(
                                                                        type_of_field: LocalText.Profile().last_name(),
                                                                        type_of_value: LocalText.Profile().last_name(),
                                                                        value: ""),
                                                                       image: Data(),
                                                                       arr_mobile_numbers: [ProfileDataModel(
                                                                        type_of_field: LocalText.PersonalDetails().mobile_number(),
                                                                        type_of_value: LocalText.PersonalDetails().primary(),
                                                                        value: "")],
                                                                       arr_email: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(),
                                                                                                    type_of_value: LocalText.PersonalDetails().primary(),
                                                                                                    value: "")],
                                                                       arr_address: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(),
                                                                                                      type_of_value: LocalText.PersonalDetails().home(),
                                                                                                      value: "")],
                                                                       arr_social_links: [ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                                                                                           type_of_value: LocalText.PersonalDetails().linkedin(),
                                                                                                           value: ""),
                                                                                          ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                                                                                           type_of_value: LocalText.PersonalDetails().twitter(),
                                                                                                           value: "")]
    )
    
    var arr_social_icons = [AssetsImage.linkedin,AssetsImage.twitter]
    var arr_social_links_placeholders = [LocalText.PersonalDetails().no_linkedin_url(),LocalText.PersonalDetails().no_twitter_url()]
    
    var did_tap_share_my_profile_block : (() -> Void)?
    var did_tap_more_button_block : (() -> Void)?
    var is_top_trusted_organization = false
    var organization_model : OrganizationListModel?
    var is_reset_selected : Bool?
    var is_my_trusted = false
    
    
    // MARK: - TABLE VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.delegate = self
        self.dataSource = self
        
        self.estimatedRowHeight = 100.0
        self.rowHeight = UITableView.automaticDimension
        
        self.removeHeaderTopPadding()
        
        self.register(UINib(nibName: self.k_organization_profile_user_details_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_organization_profile_user_details_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_my_profile_input_field_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_my_profile_input_field_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_single_button_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_single_button_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_organization_profile_principle_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_organization_profile_principle_tbl_view_cell)
    }
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section_title.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 3 {
            return self.my_profile_model.arr_mobile_numbers.count
        }
        else if section == 4 {
            return self.my_profile_model.arr_email.count
        }
        else if section == 5 {
            return self.my_profile_model.arr_address.count
        }
        else if section == 6 {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 || section == (self.section_title.count - 1) || section == (self.section_title.count - 2)) ? 0.01 : 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == (self.section_title.count - 1) || section == (self.section_title.count - 2) {
            return nil
        }
        else {
            let header_view = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
            header_view.setupData(title: self.section_title[section],font: AppFont.helvetica_bold)
            return header_view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 6
        ? UtilityManager().getPropotionalHeight(baseHeight: 856, height: 60)
        : indexPath.section == (self.section_title.count - 1)
        ? UtilityManager().getPropotionalHeight(baseHeight: 856, height: 77)
        : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ORGANIZATION PROFILE
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_organization_profile_user_details_tbl_view_cell) as! OrganizationProfileUserDetailsTblViewCell
            
            cell.is_reset_selected = self.is_reset_selected
            cell.btn_more.isHidden = !is_my_trusted

            cell.setupUI(isTopTrustedOrganization: self.is_top_trusted_organization)
            
            if let model = self.organization_model {
                cell.setupData(organization_model: model)
            }
            
            
            // MORE BUTTON PRESSED
            cell.did_tap_more_button_block = {
                if let did_tap_more_button_block = self.did_tap_more_button_block {
                    did_tap_more_button_block()
                }
            }
            
            
            // RESET OR SELECT ALL PRESSED
            cell.did_tap_reset_select_all_button_block = { is_reset_selected in
                self.is_reset_selected = is_reset_selected
                
                self.my_profile_model.arr_mobile_numbers.enumerated().forEach { index,model in
                    if self.my_profile_model.arr_mobile_numbers[index].value != "" {
                        self.my_profile_model.arr_mobile_numbers[index].is_selected = !is_reset_selected
                    }
                }
                
                self.my_profile_model.arr_email.enumerated().forEach { index,model in
                    if self.my_profile_model.arr_email[index].value != "" {
                        self.my_profile_model.arr_email[index].is_selected = !is_reset_selected
                    }
                }
                
                self.my_profile_model.arr_address.enumerated().forEach { index,model in
                    if self.my_profile_model.arr_address[index].value != "" {
                        self.my_profile_model.arr_address[index].is_selected = !is_reset_selected
                    }
                }
                
                self.my_profile_model.arr_social_links.enumerated().forEach { index,model in
                    if self.my_profile_model.arr_social_links[index].value != "" {
                        self.my_profile_model.arr_social_links[index].is_selected = !is_reset_selected
                    }
                }
                
                DispatchQueue.main.async {
                    self.reloadData()
                }
            }
            
            return cell
        }
        
        // SHARE DATA BUTTON
        else if indexPath.section == (self.section_title.count - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_single_button_tbl_view_cell) as! SingleButtonTblViewCell
            
            cell.didButtonSignlePressedBlock = { row,section in
                if let did_tap_share_my_profile_block = self.did_tap_share_my_profile_block {
                    did_tap_share_my_profile_block()
                }
            }
            
            return cell
        }
        
        // PRINCIPLE AND RULES
        else if indexPath.section == (self.section_title.count - 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_organization_profile_principle_tbl_view_cell) as! OrganizationProfilePrincipleTblViewCell
            
            if let model = self.organization_model {
                cell.setupData(organization_model: model)
            }
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_input_field_tbl_view_cell) as! MyProfileInputFieldTblViewCell
            
            cell.setupUI(is_top_trusted_organization: self.is_top_trusted_organization,
                         keyboardType: .default,
                         is_user_interaction_enabled: false,
                         is_edit_profile: false,
                         is_came_from_complete_profile: indexPath.section == 1 || indexPath.section == 2)
            
            
            // CHECK BOX PRESSED
            cell.did_button_checkbox_pressed_block = { isChecked,row,section in
                
                if section == 3 {
//                    let count = self.my_profile_model.arr_mobile_numbers.filter({ $0.is_selected == true }).count
                    
                    /// This condition is used check that minimum one mobile number is selected
//                    if count < 2 && !isChecked {
//                        UtilityManager().showToast(message: ValidationMessage.minimum_one_mobile_number_required_to_share())
//                    } else {
                        var field_data = self.my_profile_model.arr_mobile_numbers[indexPath.row]
                        field_data.is_selected = isChecked
                        self.my_profile_model.arr_mobile_numbers[indexPath.row] = field_data
//                    }
                    
                } else if section == 4 {
                    
//                    let count = self.my_profile_model.arr_email.filter({ $0.is_selected == true }).count
                    
//                    /// This condition is used check that minimum one email is selected
//                    if count < 2 && !isChecked {
//                        UtilityManager().showToast(message: ValidationMessage.minimum_one_email_required_to_share())
//                    } else {
                        var field_data = self.my_profile_model.arr_email[indexPath.row]
                        field_data.is_selected = isChecked
                        self.my_profile_model.arr_email[indexPath.row] = field_data
//                    }
                    
                } else if section == 5 {
                    
//                    let count = self.my_profile_model.arr_address.filter({ $0.is_selected == true }).count
//                    
//                    /// This condition is used check that minimum one address is selected
//                    if count < 2 && !isChecked {
//                        UtilityManager().showToast(message: ValidationMessage.minimum_one_address_required_to_share())
//                    } else {
                        var field_data = self.my_profile_model.arr_address[indexPath.row]
                        field_data.is_selected = isChecked
                        self.my_profile_model.arr_address[indexPath.row] = field_data
//                    }
                    
                } else if section == 6 {
                    
                    var field_data = self.my_profile_model.arr_social_links[indexPath.row]
                    field_data.is_selected = isChecked
                    self.my_profile_model.arr_social_links[indexPath.row] = field_data
                    
                }
                
                self.checkResetAndSelectAll()
                
                DispatchQueue.main.async {
                    UITableView.setAnimationsEnabled(false)
                    self.reloadRows(at: [indexPath], with: .none)
                    UITableView.setAnimationsEnabled(true)
                }
            }
            
            
            // FIRST NAME
            if indexPath.section == 1 {
                                
                cell.setupData(indexPath: indexPath,
                               text: self.my_profile_model.first_name.value,
                               placeholder: "\(self.section_title[indexPath.section])",
                               is_selected: true,
                               is_checkbox_enabled: false)
                
            }
            
            // LAST NAME
            else if indexPath.section == 2 {
                
                cell.setupData(indexPath: indexPath,
                               text: self.my_profile_model.last_name.value,
                               placeholder: "\(self.section_title[indexPath.section])",
                               is_selected: true,
                               is_checkbox_enabled: false)
                
            }
            
            
            // MOBILE NUMBERS
            else if indexPath.section == 3 {
                let count = self.my_profile_model.arr_mobile_numbers.count
                
                let text = count > 0
                ? "\(self.my_profile_model.arr_mobile_numbers[indexPath.row].country_code?.dialCode() ?? "") \(self.my_profile_model.arr_mobile_numbers[indexPath.row].value)"
                : "\(self.section_title[indexPath.section]) \(indexPath.row + 1)"
                
                cell.setupData(arr_dropdown_items:self.drop_down_titles[indexPath.section],
                               drop_down_title: (self.my_profile_model.arr_mobile_numbers.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_mobile_numbers[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section]) \(indexPath.row + 1)",
                               is_selected: self.my_profile_model.arr_mobile_numbers[indexPath.row].is_selected,
                               is_checkbox_enabled: text != "")
                
            }
            
            // EMAILS
            else if indexPath.section == 4 {
                
                let count = self.my_profile_model.arr_email.count
                let text = count > 0
                ? self.my_profile_model.arr_email[indexPath.row].value
                : "\(self.section_title[indexPath.section]) \(indexPath.row + 1)"
                
                cell.setupData(arr_dropdown_items:self.drop_down_titles[indexPath.section],
                               drop_down_title: (self.my_profile_model.arr_email.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_email[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section]) \(indexPath.row + 1)",
                               is_selected: self.my_profile_model.arr_email[indexPath.row].is_selected,
                               is_checkbox_enabled: text != "")
                
            }
            
            // ADDRESSES
            else if indexPath.section == 5 {
                
                let count = self.my_profile_model.arr_address.count
                let text = count > 0
                ? self.my_profile_model.arr_address[indexPath.row].value
                : "\(self.section_title[indexPath.section]) \(indexPath.row + 1)"
                
                cell.setupData(arr_dropdown_items:self.drop_down_titles[indexPath.section],
                               drop_down_title: (self.my_profile_model.arr_address.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_address[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section]) \(indexPath.row + 1)",
                               is_selected: self.my_profile_model.arr_address[indexPath.row].is_selected,
                               is_checkbox_enabled: text != "")
                
            }
            
            // SOCIAL LINKS
            else if indexPath.section == 6 {
                
                let text = self.my_profile_model.arr_social_links[indexPath.row].value
                
                cell.setupData(
                    indexPath: indexPath,
                    text: text,
                    placeholder: self.arr_social_links_placeholders[indexPath.row],
                    social_media_icon: self.arr_social_icons[indexPath.row],
                    is_selected: self.my_profile_model.arr_social_links[indexPath.row].is_selected,
                    is_social_link_checkbox_enabled: text != "")
                
                cell.setupUI(is_top_trusted_organization: self.is_top_trusted_organization,
                             keyboardType: .default,
                             is_user_interaction_enabled: false,
                             is_edit_profile: false,
                             is_social_media_textfield_hidden: false)
                
            }
            
            return cell
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    // Check if all values are reset or not
    func isReset() -> String? {
        return self.my_profile_model.arr_mobile_numbers.allSatisfy { $0.is_selected == false }
            ? ValidationMessage.you_need_to_select_atlease_one_mobile_number_and_one_email()
                : self.my_profile_model.arr_email.allSatisfy { $0.is_selected == false }
                    ? ValidationMessage.you_need_to_select_atlease_one_mobile_number_and_one_email()
//                        : self.my_profile_model.arr_address.allSatisfy { $0.is_selected == false }
//                            ?  ValidationMessage.you_need_to_select_atlease_one_mobile_number_and_one_email()
                                : nil
    }
    
    // Check if all values are selected or not
    func isSelectAll() -> Bool {
        return self.my_profile_model.arr_address.allSatisfy { $0.is_selected == true } && self.my_profile_model.arr_email.allSatisfy { $0.is_selected == true } &&
        self.my_profile_model.arr_mobile_numbers.allSatisfy { $0.is_selected == true } &&
        self.my_profile_model.arr_social_links.allSatisfy { $0.is_selected == true }
    }
    
    // Check if all values are selected or reset or nothing
    func checkResetAndSelectAll() {
        if self.isSelectAll() {
            self.is_reset_selected = false
        } else {
            self.is_reset_selected = nil
        }
        
        DispatchQueue.main.async {
            self.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}
