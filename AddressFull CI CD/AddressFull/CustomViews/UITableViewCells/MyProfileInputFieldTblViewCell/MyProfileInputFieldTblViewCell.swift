//
//  MyProfileInputFieldTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class MyProfileInputFieldTblViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    var did_button_checkbox_pressed_block : ((_ isChecked: Bool, _ row: Int, _ section: Int) -> Void)!
    var did_drop_down_select_block : ((_ drop_down_text: String) -> Void)!
    var did_delete_btn_pressed_block : (() -> Void)!
    var did_country_code_btn_pressed_block : ((_ index:Int) -> Void)!
    var arr_dropdown_items = [""]
    var is_top_trusted_organization = false
    var is_unique_number = false
    
    @IBOutlet weak var btn_profile_data_view: UIButton!
    @IBOutlet weak var view_first_name_last_name: UIView!
    @IBOutlet weak var btn_first_name_last_name_checkbox: BasePoppinsRegularButton!
    @IBOutlet weak var view_first_name_last_name_checkbox: UIView!
    @IBOutlet weak var txt_first_name_last_name: BasePoppinsRegularTextField!
    @IBOutlet weak var view_delete: UIView!
    @IBOutlet weak var btn_country_code: UIButton!
    @IBOutlet weak var view_country_code: UIView!
    @IBOutlet weak var lbl_field_index: AFLabelLight!
    @IBOutlet weak var view_pipe_two: UIView!
    @IBOutlet weak var view_dropdown: UIView!
    @IBOutlet weak var view_pipe: UIView!
    @IBOutlet weak var view_seperator: UIView!
    @IBOutlet weak var txt_social_links: BasePoppinsRegularTextField!
    @IBOutlet weak var social_image: UIImageView!
    @IBOutlet weak var social_media_view: UIView!
    @IBOutlet weak var stack_view_delete: UIStackView!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var profile_data_view: UIView!
    @IBOutlet weak var dropdown_select_type: BaseIOSDropDown!
    @IBOutlet weak var btn_input_field_height: NSLayoutConstraint!
    @IBOutlet weak var txt_data_input: BasePoppinsRegularTextField!
    @IBOutlet weak var btn_social_links_checkbox: BasePoppinsRegularButton!
    @IBOutlet weak var bg_view_pipe_three: UIView!
    @IBOutlet weak var btn_profile_data_checkbox: BasePoppinsRegularButton!
    @IBOutlet weak var view_profile_data_check_box: UIView!
    @IBOutlet weak var view_pipe_three: UIView!
    
    
    //MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: CUSTOM FUCNTIONS
    
    func setupUI(is_top_trusted_organization : Bool = true,
                 keyboardType : UIKeyboardType = .default,
                 is_user_interaction_enabled : Bool = false,
                 is_edit_profile : Bool = false,
                 is_social_media_textfield_hidden : Bool = true,
                 is_from_login: Bool = false,
                 is_came_from_complete_profile : Bool = false,
                 is_country_code_hidden : Bool = true,
                 show_red_border : Bool = false) {
        
        self.selectionStyle = .none
        self.txt_data_input.keyboardType = keyboardType
        
        self.profile_data_view.isHidden = is_came_from_complete_profile || !is_social_media_textfield_hidden
        self.view_first_name_last_name.isHidden = !is_came_from_complete_profile
        self.social_media_view.isHidden = is_came_from_complete_profile || is_social_media_textfield_hidden
        self.stack_view_delete.isHidden = !is_edit_profile
        
        self.view_profile_data_check_box.isHidden = is_top_trusted_organization
        self.view_first_name_last_name_checkbox.isHidden = is_top_trusted_organization
        self.btn_social_links_checkbox.isHidden = is_top_trusted_organization
        
        self.view_country_code.isHidden = is_country_code_hidden
        self.bg_view_pipe_three.isHidden = is_country_code_hidden
        self.view_pipe_two.isHidden = is_from_login
        self.view_delete.isHidden = is_from_login
        
        self.is_top_trusted_organization = is_top_trusted_organization
        
        self.txt_data_input.isUserInteractionEnabled = is_user_interaction_enabled
        self.dropdown_select_type.isUserInteractionEnabled = is_user_interaction_enabled
        self.txt_social_links.isUserInteractionEnabled = is_user_interaction_enabled
        self.txt_first_name_last_name.isUserInteractionEnabled = is_user_interaction_enabled
        self.btn_country_code.isUserInteractionEnabled = is_user_interaction_enabled
        
        self.btn_profile_data_checkbox.setStyleWithout(border: true, backgroundColor: .clear)
        self.btn_first_name_last_name_checkbox.setStyleWithout(border: true, backgroundColor: .clear)
        self.btn_social_links_checkbox.setStyleWithout(border: true, backgroundColor: .clear)
        
        if !is_top_trusted_organization {
            self.txt_social_links.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: UtilityManager().getPropotionalHeight(baseHeight: 856, height: 45))
        }
        
        self.dropdown_select_type.clearsOnBeginEditing = false
        self.dropdown_select_type.checkMarkEnabled = false
        self.dropdown_select_type.selectedRowColor = .white
        self.dropdown_select_type.isSearchEnable = false
        
        self.profile_data_view.setupLayer(cornerRadius: 14)
        self.social_media_view.setupLayer(cornerRadius: 14)
        self.view_first_name_last_name.setupLayer(cornerRadius: 14)
        
        self.view_first_name_last_name.backgroundColor = is_from_login ?  AppColor.primary_gray() : .white
        self.social_media_view.backgroundColor = is_from_login ?  AppColor.primary_gray() : .white
        self.profile_data_view.backgroundColor = is_from_login ?  AppColor.primary_gray() : .white
        self.view_seperator.backgroundColor = is_from_login ? .white : AppColor.primary_gray()
        self.view_pipe.backgroundColor = is_from_login ? .white : AppColor.primary_gray()
        self.view_pipe_two.backgroundColor = is_from_login ? .white : AppColor.primary_gray()
        self.view_pipe_three.backgroundColor = is_from_login ? .white : AppColor.primary_gray()
        
        self.profile_data_view.setupLayer(borderColor: show_red_border ? .red : .clear,
                                          borderWidth: 1,
                                          cornerRadius: self.profile_data_view.layer.cornerRadius)
        
        self.view_first_name_last_name.setupLayer(borderColor: show_red_border ? .red : .clear,
                                                  borderWidth: 1,
                                                  cornerRadius: self.view_first_name_last_name.layer.cornerRadius)
        
        self.social_media_view.setupLayer(borderColor: show_red_border ? .red : .clear,
                                          borderWidth: 1,
                                          cornerRadius: self.social_media_view.layer.cornerRadius)
        
        if show_red_border && !GlobalVariables.shared.opened_keyboard_for_validation {
            self.contentView.resignRespondersInView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                
                if !self.social_media_view.isHidden {
                    self.txt_social_links.becomeFirstResponder()
                } else if !self.view_first_name_last_name.isHidden {
                    self.txt_first_name_last_name.becomeFirstResponder()
                } else if !self.profile_data_view.isHidden {
                    self.txt_data_input.becomeFirstResponder()
                }
                
                GlobalVariables.shared.opened_keyboard_for_validation = true
            })
        }
    }
    
    func setupData(arr_dropdown_items : [String] = [""],
                   drop_down_title : String = "",
                   indexPath : IndexPath,
                   text : String = "",
                   complete_profile_textfiled_text : String = "",
                   placeholder : String = "",
                   social_media_icon : String = "",
                   is_selected : Bool = false,
                   is_social_link_checkbox_enabled: Bool = true,
                   is_checkbox_enabled: Bool = true,
                   country_code: String? = nil) {
        
        self.btn_profile_data_view.isHidden = !self.is_unique_number
        
        self.txt_first_name_last_name.text = complete_profile_textfiled_text
        
        self.btn_social_links_checkbox.isUserInteractionEnabled = is_social_link_checkbox_enabled
        self.btn_profile_data_checkbox.isUserInteractionEnabled = is_checkbox_enabled
        
        self.lbl_field_index.text = placeholder
        
        DispatchQueue.main.async {
            if text == "" {
                self.txt_first_name_last_name.text = ""
                self.txt_data_input.text = ""
                self.txt_social_links.text = ""
                let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont(name: AppFont.helvetica_regular, size: 14) ?? UIFont.systemFont(ofSize: 14) ]
                self.txt_data_input.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
                self.txt_social_links.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
                self.txt_first_name_last_name.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            } else {
                self.txt_data_input.placeholder = ""
                self.txt_first_name_last_name.placeholder = ""
                self.txt_social_links.placeholder = ""
                self.txt_first_name_last_name.text = text
                self.txt_data_input.text = text
                self.txt_social_links.text = text
            }
        }
        
        if social_media_icon != "" {
            self.social_image.image = UIImage(named: social_media_icon)
        }
        
        self.txt_data_input.section = indexPath.section
        self.txt_data_input.row = indexPath.row
        
        self.txt_social_links.section = indexPath.section
        self.txt_social_links.row = indexPath.row
        
        self.dropdown_select_type.section = indexPath.section
        self.dropdown_select_type.row = indexPath.row
        
        self.btn_profile_data_checkbox.section = indexPath.section
        self.btn_profile_data_checkbox.row = indexPath.row
        
        self.btn_first_name_last_name_checkbox.section = indexPath.section
        self.btn_first_name_last_name_checkbox.row = indexPath.row
        
        self.btn_social_links_checkbox.section = indexPath.section
        self.btn_social_links_checkbox.row = indexPath.row
        
        self.txt_first_name_last_name.section = indexPath.section
        self.txt_first_name_last_name.row = indexPath.row
        self.btn_country_code.tag = indexPath.row
        
        self.dropdown_select_type.text = drop_down_title == "" ? arr_dropdown_items.first : drop_down_title
        self.dropdown_select_type.textColor = !self.is_top_trusted_organization ? is_selected ? .black : AppColor.seperator_gray() : .black
        self.dropdown_select_type.optionArray = []
        
        self.btn_profile_data_checkbox.is_button_selected = is_selected
        self.btn_profile_data_checkbox.setImage(UIImage(named: is_selected ? AssetsImage.checkbox_checked : AssetsImage.light_checkbox_unchecked), for: .normal)
        
        self.btn_first_name_last_name_checkbox.is_button_selected = is_selected
        self.btn_first_name_last_name_checkbox.setImage(UIImage(named: is_selected ? AssetsImage.checkbox_checked_grey : AssetsImage.light_checkbox_unchecked), for: .normal)
        
        self.btn_social_links_checkbox.is_button_selected = is_selected
        self.btn_social_links_checkbox.setImage(UIImage(named: is_selected ? AssetsImage.checkbox_checked : AssetsImage.light_checkbox_unchecked), for: .normal)
        
        
        if let country = Country.getCountryFromISOCode(from: country_code ?? "") {
            self.btn_country_code.setTitle("\(country.flag)  \(country.dialCode ?? "")", for: .normal)
        }
        
        self.btn_country_code.imageView?.contentMode = .scaleAspectFit
        self.btn_country_code.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.btn_country_code.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.btn_country_code.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        
        self.dropdown_select_type.didSelect { (selectedText,index,id) in
            self.dropdown_select_type.text = selectedText
            if self.did_drop_down_select_block != nil {
                self.did_drop_down_select_block(selectedText)
            }
        }
        
        DispatchQueue.main.async {
            self.arr_dropdown_items = arr_dropdown_items
            self.arr_dropdown_items.forEach { title in
                self.dropdown_select_type.optionArray.append(title)
            }
        }
    }
    

    // MARK: BUTTON'S ACTIONS
    
    @IBAction func btn_delete_pressed(_ sender: UIButton) {
        if self.did_delete_btn_pressed_block != nil {
            self.did_delete_btn_pressed_block()
        }
    }
    
    @IBAction func btn_input_field_trailing_buttonPressed(_ sender: BasePoppinsRegularButton) {
        
        sender.is_button_selected = !sender.is_button_selected
        sender.setImage(UIImage(named: sender.is_button_selected ? AssetsImage.checkbox_checked : AssetsImage.light_checkbox_unchecked), for: .normal)
        
        if self.did_button_checkbox_pressed_block != nil {
            self.did_button_checkbox_pressed_block(sender.is_button_selected, sender.row, sender.section)
        }
    }
    
    @IBAction func btnCountryCodePressed(_ sender: UIButton) {
        if let did_country_code_btn_pressed_block = self.did_country_code_btn_pressed_block {
            did_country_code_btn_pressed_block(sender.tag)
        }
    }
    
    @IBAction func btnProfileDataViewPressed(_ sender: UIButton) {
        UtilityManager().showToast(message: ValidationMessage.you_can_not_modify_this_data())
    }
}
