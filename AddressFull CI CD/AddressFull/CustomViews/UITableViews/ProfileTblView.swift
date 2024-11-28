//
//  ProfileTblView.swift
//  AddressFull
//
//  Created by Sneh on 11/27/23.
//

import Foundation
import UIKit


class ProfileTblView : CustomTableView , UITableViewDelegate , UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let complete_profile_tbl_view_cell = ProfileTBLViewCell.identifier
    let k_my_profile_input_field_tbl_view_cell = MyProfileInputFieldTblViewCell.identifier
    let k_my_profile_user_details_tbl_view_cell = MyProfileUserDetailsTblViewCell.identifier
    let k_my_profile_add_input_field_tbl_view_cell = MyProfileAddInputFieldTblViewCell.identifier
    let k_single_button_tbl_view_cell = SingleButtonTblViewCell.identifier
    
    
    let section_title = [
        "",
        LocalText.Profile().first_name_star(),
        LocalText.Profile().last_name_star(),
        LocalText.SignUpScreen().mobile_number_star(),
        LocalText.MyProfile().email_star(),
        LocalText.MyProfile().address_star(),
        LocalText.MyProfile().social(),
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
    
    var my_profile_model : PersonalDetailsModel = PersonalDetailsModel(
        first_name: ProfileDataModel(type_of_field: LocalText.Profile().first_name(),
                                     type_of_value: LocalText.Profile().first_name(),
                                     value: ""),
        last_name: ProfileDataModel(type_of_field: LocalText.Profile().last_name(),
                                    type_of_value: LocalText.Profile().last_name(),
                                    value: ""),
        image: Data(),
        arr_mobile_numbers: [ProfileDataModel(
            type_of_field: LocalText.PersonalDetails().mobile_number(),
            type_of_value: LocalText.PersonalDetails().primary(),
            value: UserDetailsModel.shared.mobile_number,
            country_code: Country.getCurrentCountry()?.code)],
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
    var is_edit_mode = false
    var is_from_login = false
    
    var did_delete_pressed_block : ((_ model: ProfileDataModel,_ indexPath: IndexPath) -> Void)!
    var image_completion_block : ((_ image : UIImage?) -> Void)!
    var did_save_pressed_block : ((_ model: PersonalDetailsModel) -> Void)!
    var did_country_code_btn_pressed_block : ((_ index: Int) -> Void)!
    var validation_failure_indexpath : IndexPath?
    
    
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
        
        self.register(UINib(nibName: self.complete_profile_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.complete_profile_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_my_profile_input_field_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_my_profile_input_field_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_my_profile_user_details_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_my_profile_user_details_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_my_profile_input_field_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_my_profile_input_field_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_my_profile_add_input_field_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_my_profile_add_input_field_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_single_button_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_single_button_tbl_view_cell)
    }
    
    
    func getLastCell(ofSection: Int, withCurrentIndex: Int) -> Bool {
        if ofSection == 0 || ofSection == 1 || ofSection == 2 {
            return true
        }
        else if ofSection == 3 {
            return withCurrentIndex == self.my_profile_model.arr_mobile_numbers.count
        }
        else if ofSection == 4 {
            return withCurrentIndex == self.my_profile_model.arr_email.count
        }
        else if ofSection == 5  {
            return withCurrentIndex == self.my_profile_model.arr_address.count
        }
        else {
            return false
        }
    }
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section_title.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            let count = self.my_profile_model.arr_mobile_numbers.count
            return self.is_edit_mode && !self.is_from_login && count > 0 ? count + 1 : count > 0 ? count : 1
        }
        else if section == 4 {
            let count = self.my_profile_model.arr_email.count
            return self.is_edit_mode && !self.is_from_login && count > 0 ? count + 1 : count > 0 ? count : 1
        }
        else if section == 5 {
            let count = self.my_profile_model.arr_address.count
            return self.is_edit_mode && !self.is_from_login && count > 0 ? count + 1 : count > 0 ? count : 1
        }
        else if section == 6 {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0  || section == self.section_title.count - 1) ? 0.01 : 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == self.section_title.count - 1 {
            return nil
        }
        else {
            let headerView = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
           
            headerView.setupData(title: self.is_edit_mode 
                                        ? self.section_title[section]
                                            : self.section_title[section].removeStarFromEnd(),
                                 font: AppFont.helvetica_bold,
                                 background_color: .clear)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
            
        } else if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 6 {
            
            return UtilityManager().getPropotionalHeight(baseHeight: 856, height: 60)
            
        } else if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5) {
            if self.getLastCell(ofSection: indexPath.section, withCurrentIndex: indexPath.row) && self.is_edit_mode {
                return 25.0
            }
            else {
                return UITableView.automaticDimension
            }
        } else {
            return UtilityManager().getPropotionalHeight(baseHeight: 856, height: 77)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_user_details_tbl_view_cell) as! MyProfileUserDetailsTblViewCell
            
            cell.setupUI(profile_model: self.my_profile_model,
                         is_from_login: self.is_from_login,
                         is_edit_mode: self.is_edit_mode)
            
            // PROFILE PHOTO
            cell.did_profile_picture_button_clicked_block = { () in
                if self.is_edit_mode {
                    if let top_vc = UIApplication.topViewController() {
                        
                        top_vc.popupAlert(title: AppInfo.app_name,
                                          message: LocalText.ImagePicker().image_selection_message(),
                                          alertStyle: .actionSheet,
                                          actionTitles: [LocalText.ImagePicker().camera(),
                                                         LocalText.ImagePicker().gallery(),
                                                         LocalText.AlertButton().cancel()])
                        { index, title, textFieldText in
                            
                            
                            
                            if title != LocalText.AlertButton().cancel() {
                                let sourceType : UIImagePickerController.SourceType = (title == LocalText.ImagePicker().camera() ? .camera : .photoLibrary)
                                
                                top_vc.view.showProgressBar()
                                
                                let imagePicker = UIImagePickerController()
                                
                                if #available(iOS 14, *) {
                                    
                                    PermissionManager.shared.checkPermission(for: [(sourceType == .camera) ? .camera : .photoLibrary], parentController: top_vc) {
                                        DispatchQueue.main.async {
                                            imagePicker.delegate = self
                                            imagePicker.allowsEditing = false
                                            imagePicker.sourceType = sourceType
                                            imagePicker.modalPresentationStyle = .overFullScreen
                                            top_vc.present(imagePicker, animated: true) {
                                                top_vc.view.hideProgressBar()
                                            }
                                            
                                            self.image_completion_block = { image in
                                                cell.img_vIew_user_profile.image = image
                                                if let image = image {
                                                    self.my_profile_model.image = image.pngData()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    top_vc.showPopupAlert(title: AppInfo.app_name,
                                                        message: Message.upgrade_your_os_version(),
                                                        leftTitle: nil,
                                                        rightTitle: LocalText.AlertButton().ok(),
                                                        close_button_hidden: true,
                                                        didPressedLeftButton: nil,
                                                        didPressedRightButton: nil)
                                }
                            }
                        }
                    }
                }
            }
            
            return cell
        }
        
        // FIRST NAME ,LAST NAME ,SOCIAL LINKS
        else if indexPath.section == 1 ||  indexPath.section == 2 || indexPath.section == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_input_field_tbl_view_cell) as! MyProfileInputFieldTblViewCell
            
            
            cell.txt_social_links.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.txt_first_name_last_name.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            if self.validation_failure_indexpath == indexPath {
                if indexPath.section == 6 {
                    cell.txt_social_links.becomeFirstResponder()
                } else {
                    cell.txt_first_name_last_name.becomeFirstResponder()
                }
            }
            
            cell.is_unique_number = false
            
            cell.setupUI(is_user_interaction_enabled: self.is_edit_mode,
                         is_edit_profile: self.is_edit_mode,
                         is_social_media_textfield_hidden: indexPath.section == 1 || indexPath.section == 2,
                         is_from_login: self.is_from_login,
                         is_came_from_complete_profile: indexPath.section == 1 ||  indexPath.section == 2,
                         show_red_border: self.validation_failure_indexpath == indexPath)
            
            cell.setupData(indexPath: indexPath,
                           text: indexPath.section == 1 ? self.my_profile_model.first_name.value
                                                            : indexPath.section == 2
                           ? self.my_profile_model.last_name.value
                                                                    : self.my_profile_model.arr_social_links[indexPath.row].value,
                           placeholder: indexPath.section == 1 || indexPath.section == 2 ? "\(self.section_title[indexPath.section].removeStarFromEnd())" : self.arr_social_links_placeholders[indexPath.row],
                           social_media_icon: self.arr_social_icons[indexPath.row])
            
            return cell
            
        }
        
        // MOBILE NUMBER
        else if indexPath.section == 3 {
            if indexPath.row == self.my_profile_model.arr_mobile_numbers.count && self.is_edit_mode && !self.is_from_login {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_add_input_field_tbl_view_cell) as! MyProfileAddInputFieldTblViewCell
                
                cell.btn_add_another.section = indexPath.section
                cell.btn_add_another.row = indexPath.row
                cell.btn_add_another.addTarget(self, action: #selector(self.btnAddAnotherPressed(_:)), for: .touchUpInside)
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_input_field_tbl_view_cell) as! MyProfileInputFieldTblViewCell
                
                let count = self.my_profile_model.arr_mobile_numbers.count
                
                let country = count > 0 && count > indexPath.row
                                ? Country.getCountryFromISOCode(from: (self.my_profile_model.arr_mobile_numbers[indexPath.row].country_code ?? Country.getCurrentCountry()?.code) ?? "")
                                        : Country.getCurrentCountry()
                
                
                let text = (self.is_edit_mode && count > 0)
                ? (self.my_profile_model.arr_mobile_numbers[indexPath.row].value)
                : count > 0 && count > indexPath.row
                ? "\(country?.dialCode ?? "") \(self.my_profile_model.arr_mobile_numbers[indexPath.row].value)"
                : "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)"
                
                if self.validation_failure_indexpath == indexPath {
                    cell.txt_data_input.becomeFirstResponder()
                }
                
                cell.is_unique_number = indexPath.row == 0 && self.is_edit_mode
                
                cell.setupUI(keyboardType: .phonePad,
                             is_user_interaction_enabled: self.is_edit_mode,
                             is_edit_profile: self.is_edit_mode,
                             is_from_login: self.is_from_login,
                             is_country_code_hidden: !self.is_edit_mode,
                             show_red_border: self.validation_failure_indexpath == indexPath)
                
                cell.setupData(arr_dropdown_items: self.drop_down_titles[indexPath.section], drop_down_title: (self.my_profile_model.arr_mobile_numbers.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_mobile_numbers[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)",
                               country_code: country?.code)
                
                cell.did_country_code_btn_pressed_block = { index in
                    if let did_country_code_btn_pressed_block = self.did_country_code_btn_pressed_block {
                        did_country_code_btn_pressed_block(index)
                    }
                }
                
                cell.did_drop_down_select_block = { drop_down_text in
                    self.my_profile_model.arr_mobile_numbers[indexPath.row].type_of_value = drop_down_text
                }
                
                cell.did_delete_btn_pressed_block = {
                    
                    if self.my_profile_model.arr_mobile_numbers.count > 1 {
                        
                        if let did_delete_pressed_block = self.did_delete_pressed_block {
                            
                            did_delete_pressed_block( self.my_profile_model.arr_mobile_numbers[indexPath.row],indexPath)
                        }
                    } else {
                        
                        UtilityManager().showToast(message: "\(Message.please_enter_another()) \(self.section_title[indexPath.section].removeStarFromEnd()) \(Message.to_delete_this()) \(self.section_title[indexPath.section].removeStarFromEnd())")
                        
                    }
                }
                
                cell.txt_data_input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.dropdown_select_type.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
                return cell
            }
        }
        
        // EMAIL
        else if indexPath.section == 4 {
            if indexPath.row == self.my_profile_model.arr_email.count && self.is_edit_mode && !self.is_from_login {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_add_input_field_tbl_view_cell) as! MyProfileAddInputFieldTblViewCell
                
                cell.btn_add_another.section = indexPath.section
                cell.btn_add_another.row = indexPath.row
                cell.btn_add_another.addTarget(self, action: #selector(self.btnAddAnotherPressed(_:)), for: .touchUpInside)
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_input_field_tbl_view_cell) as! MyProfileInputFieldTblViewCell
                
                let count = self.my_profile_model.arr_email.count
                
                let text = (self.is_edit_mode && count > 0)
                ? (self.my_profile_model.arr_email[indexPath.row].value)
                : count > 0 && count > indexPath.row
                ? self.my_profile_model.arr_email[indexPath.row].value
                : "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)"
                
                if self.validation_failure_indexpath == indexPath {
                    cell.txt_data_input.becomeFirstResponder()
                }
                
                cell.is_unique_number = false
                
                cell.setupUI(keyboardType: .emailAddress,
                             is_user_interaction_enabled: self.is_edit_mode,
                             is_edit_profile: self.is_edit_mode,
                             is_from_login: self.is_from_login,
                             show_red_border: self.validation_failure_indexpath == indexPath)
                
                cell.setupData(arr_dropdown_items:self.drop_down_titles[indexPath.section], drop_down_title: (self.my_profile_model.arr_email.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_email[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)")
                
                cell.did_drop_down_select_block = { drop_down_text in
                    self.my_profile_model.arr_email[indexPath.row].type_of_value = drop_down_text
                }
                
                cell.did_delete_btn_pressed_block = {
                   
                    if self.my_profile_model.arr_email.count > 1 {
                      
                        if let did_delete_pressed_block = self.did_delete_pressed_block {
                            
                            did_delete_pressed_block( self.my_profile_model.arr_email[indexPath.row],indexPath)
                        }
                    } else {
                        
                        UtilityManager().showToast(message: "\(Message.please_enter_another()) \(self.section_title[indexPath.section].removeStarFromEnd()) \(Message.to_delete_this()) \(self.section_title[indexPath.section].removeStarFromEnd())")
                        }
                }
                
                cell.txt_data_input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.dropdown_select_type.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
                return cell
            }
        }
        
        // ADDRESS
        else if indexPath.section == 5 {
            if indexPath.row == self.my_profile_model.arr_address.count && self.is_edit_mode && !self.is_from_login {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_add_input_field_tbl_view_cell) as! MyProfileAddInputFieldTblViewCell
                
                cell.btn_add_another.section = indexPath.section
                cell.btn_add_another.row = indexPath.row
                cell.btn_add_another.addTarget(self, action: #selector(self.btnAddAnotherPressed(_:)), for: .touchUpInside)
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: self.k_my_profile_input_field_tbl_view_cell) as! MyProfileInputFieldTblViewCell
                
                let count = self.my_profile_model.arr_address.count
                
                let text = (self.is_edit_mode && count > 0)
                ? (self.my_profile_model.arr_address[indexPath.row].value)
                : count > 0 && count > indexPath.row
                ? self.my_profile_model.arr_address[indexPath.row].value
                : "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)"
                
                
                if self.validation_failure_indexpath == indexPath {
                    cell.txt_data_input.becomeFirstResponder()
                }
                
                cell.is_unique_number = false
                
                cell.setupUI(keyboardType: .default,
                             is_user_interaction_enabled: self.is_edit_mode,
                             is_edit_profile: self.is_edit_mode,
                             is_from_login: self.is_from_login,
                             show_red_border: self.validation_failure_indexpath == indexPath)
                
                cell.setupData(arr_dropdown_items:self.drop_down_titles[indexPath.section], drop_down_title: (self.my_profile_model.arr_address.count == indexPath.row)
                               ? self.drop_down_titles[indexPath.section].first ?? ""
                               : self.my_profile_model.arr_address[indexPath.row].type_of_value,
                               indexPath: indexPath,
                               text: text,
                               placeholder: "\(self.section_title[indexPath.section].removeStarFromEnd()) \(indexPath.row + 1)")
                
                cell.did_drop_down_select_block = { drop_down_text in
                    self.my_profile_model.arr_address[indexPath.row].type_of_value = drop_down_text
                }
                
                cell.did_delete_btn_pressed_block = {
                    
                    if self.my_profile_model.arr_address.count > 1 {
                       
                        if let did_delete_pressed_block = self.did_delete_pressed_block {
                            did_delete_pressed_block( self.my_profile_model.arr_address[indexPath.row],indexPath)
                        }
                    } else {
                        
                        UtilityManager().showToast(message: "\(Message.please_enter_another()) \(self.section_title[indexPath.section].removeStarFromEnd()) \(Message.to_delete_this()) \(self.section_title[indexPath.section].removeStarFromEnd())")
                    }
                }
                
                cell.txt_data_input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                cell.dropdown_select_type.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
                return cell
            }
        }
        
        // SAVE BUTTON
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.k_single_button_tbl_view_cell) as! SingleButtonTblViewCell
            
            cell.setupUI()
            cell.btn_single.setTitle(self.is_edit_mode ? LocalText.MyProfile().save() : LocalText.MyProfile().edit(), for: .normal)
            cell.btn_single.addTarget(self, action: #selector(self.btnEditSharePressed(_:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    
    //MARK: BUTTON'S ACTIONS
    
    @objc func btnAddAnotherPressed(_ sender: BasePoppinsRegularButton) {
        
        self.showProgressBar()
        
        if sender.section == 3 {
            if self.my_profile_model.arr_mobile_numbers.count < MaximumProfileData().count {
                self.my_profile_model.arr_mobile_numbers.append(ProfileDataModel(
                    type_of_field: LocalText.PersonalDetails().mobile_number(),
                    type_of_value: LocalText.PersonalDetails().primary(),
                    value: "",
                    country_code: Country.getCurrentCountry()?.code))
                
                DispatchQueue.main.async {
                    self.reloadSections(IndexSet(integer: sender.section), with: .right)
                }
            } else {
                UtilityManager().showToast(message: "\(ValidationMessage.you_can_add_maximum()) \(MaximumProfileData().count) \(LocalText.SignUpScreen().mobile_numbers())")
            }
        }
        else if sender.section == 4 {
            if self.my_profile_model.arr_email.count < MaximumProfileData().count {
                self.my_profile_model.arr_email.append(
                    ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(),
                                     type_of_value: LocalText.PersonalDetails().primary(),
                                     value: ""))
                
                DispatchQueue.main.async {
                    self.reloadSections(IndexSet(integer: sender.section), with: .right)
                }
            } else {
                UtilityManager().showToast(message: "\(ValidationMessage.you_can_add_maximum()) \(MaximumProfileData().count) \(LocalText.PersonalDetails().emails())")
            }
        }
        else if sender.section == 5 {
            if self.my_profile_model.arr_address.count < MaximumProfileData().count {
                self.my_profile_model.arr_address.append(
                    ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(),
                                     type_of_value: LocalText.PersonalDetails().home(),
                                     value: ""))
                
                DispatchQueue.main.async {
                    self.reloadSections(IndexSet(integer: sender.section), with: .right)
                }
            } else {
                UtilityManager().showToast(message: "\(ValidationMessage.you_can_add_maximum()) \(MaximumProfileData().count) \(LocalText.PersonalDetails().addresses())")
            }
        }
        
        DispatchQueue.main.async {
            self.hideProgressBar()
        }
    }
    
    
    @objc func btnEditSharePressed(_ sender: BasePoppinsRegularButton) {
        self.validation_failure_indexpath = nil
        
        if GlobalVariables.shared.sync_data_completed {
            if self.is_edit_mode {
                let profile_model = PersonalDetailsModel(first_name: self.my_profile_model.first_name,
                                                         last_name: self.my_profile_model.last_name,
                                                         image: self.my_profile_model.image,
                                                         arr_mobile_numbers: self.my_profile_model.arr_mobile_numbers, arr_email: self.my_profile_model.arr_email, arr_address: self.my_profile_model.arr_address, arr_social_links: self.my_profile_model.arr_social_links)
                let validation = ProfileViewModel().validate(request_model: profile_model)
                
                if validation.is_success {
                    
                    if let did_save_pressed_block = self.did_save_pressed_block {
                        did_save_pressed_block(self.my_profile_model)
                    }
                    
                } else  {
                    
                    UtilityManager().showToast(message: validation.str_error_message ?? "")
                    
                    
                    self.validation_failure_indexpath = IndexPath(row: validation.row ?? 0,
                                                                  section: validation.section ?? 0)
                    
                    DispatchQueue.main.async {
                        
                        GlobalVariables.shared.opened_keyboard_for_validation = false
                        
                        self.scrollToRow(at: IndexPath(row: validation.row ?? 0,
                                                       section: validation.section ?? 0),
                                         at: .middle,
                                         animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            self.reloadData()
                        })
                    }
                }
            } else {
                
                self.is_edit_mode = !self.is_edit_mode
                
                DispatchQueue.main.async {
                    self.reloadData()
                }
            }
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
}

// MARK: - EXTENSION TEXTFIELD

extension ProfileTblView : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // TEXT FIELD
        if let textField = textField as? BasePoppinsRegularTextField {
                if textField.section == 1 {
                    self.my_profile_model.first_name.value = textField.text ?? ""
                } else if textField.section == 2 {
                    self.my_profile_model.last_name.value = textField.text ?? ""
                } else if textField.section == 3 {
                    self.my_profile_model.arr_mobile_numbers[textField.row].value = textField.text ?? ""
                } else if textField.section == 4 {
                    self.my_profile_model.arr_email[textField.row].value = textField.text ?? ""
                } else if textField.section == 5 {
                    self.my_profile_model.arr_address[textField.row].value = textField.text ?? ""
                } else if textField.section == 6 {
                    self.my_profile_model.arr_social_links[textField.row].value = textField.text ?? ""
                }
        }
        
        // DROP DOWN
        else if let textField = textField as? BaseIOSDropDown {
            if let text = textField.text?.trimmingCharacters(in: .whitespaces), text == "" {
                textField.text = self.drop_down_titles[textField.section].first
                if textField.section == 3 {
                    self.my_profile_model.arr_mobile_numbers[textField.row].type_of_value = text
                } else if textField.section == 4 {
                    self.my_profile_model.arr_email[textField.row].type_of_value = text
                } else if textField.section == 5 {
                    self.my_profile_model.arr_address[textField.row].type_of_value = text
                }
            }
        }
    }
}


// MARK: - EXTENSION IMAGE PICKER

extension ProfileTblView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if self.image_completion_block != nil {
                self.image_completion_block(img.fixOrientation())
            }
            picker.dismiss(animated: true)
        }
    }
}
