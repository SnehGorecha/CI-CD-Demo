//
//  SharedDataDetailsTblView.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation
import UIKit

class SharedDataDetailsTblView : UITableView , UITableViewDelegate , UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_shared_data_details_tbl_view_cell = SharedDataDetailsTblViewCell.identifier
    var shared_data_list_model : SharedDataListModel?
    var is_right_label_hidden = false
    var completion : ((CGFloat) -> Void)?
    var user_profile_model = PersonalDetailsModel(
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
    
    // MARK: - TABLE VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.delegate = self
        self.dataSource = self
        self.removeHeaderTopPadding()
        self.estimatedRowHeight = 20.0
        self.clipsToBounds = true
        self.rowHeight = UITableView.automaticDimension
        self.layer.masksToBounds = false
        self.register(UINib(nibName: self.k_shared_data_details_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_shared_data_details_tbl_view_cell)
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                if let completion = self.completion {
                    completion(newsize.height)
                }
            }
        }
    }
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return self.getAvailableSharedData(for: self.user_profile_model.arr_mobile_numbers, from: self.shared_data_list_model?.mobile_number ?? []).count
        case 2:
            return self.getAvailableSharedData(for: self.user_profile_model.arr_email, from: self.shared_data_list_model?.email_id ?? []).count
        case 3:
            return self.getAvailableSharedData(for: self.user_profile_model.arr_address, from: self.shared_data_list_model?.address ?? []).count
        case 4:
            return self.shared_data_list_model?.shared_social_data?.linkedin != "" || self.shared_data_list_model?.shared_social_data?.twitter != "" ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        case 1:
            return (self.getAvailableSharedData(for: self.user_profile_model.arr_mobile_numbers, from: self.shared_data_list_model?.mobile_number ?? []).count > 0) ? 40 : 0
        case 2:
            return (self.getAvailableSharedData(for: self.user_profile_model.arr_email, from: self.shared_data_list_model?.email_id ?? []).count > 0) ? 40 : 0
        case 3:
            return (self.getAvailableSharedData(for: self.user_profile_model.arr_address, from: self.shared_data_list_model?.address ?? []).count > 0) ? 40 : 0
        case 4:
            return self.shared_data_list_model?.shared_social_data?.linkedin != "" || self.shared_data_list_model?.shared_social_data?.twitter != "" ? 40 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
        
        switch section {
        case 0:
            
            headerView.setupData(title: LocalText.Profile().name(),font: AppFont.helvetica_bold,background_color: .clear)
            return headerView
            
        case 1:
            if self.shared_data_list_model?.mobile_number?.count ?? 0 > 0 {
                headerView.setupData(title: LocalText.PersonalDetails().mobile_number(),font: AppFont.helvetica_bold,background_color: .clear)
                return headerView
            } else {
                return nil
            }
            
        case 2:
            if self.shared_data_list_model?.email_id?.count ?? 0 > 0 {
                headerView.setupData(title: LocalText.PersonalDetails().email(),font: AppFont.helvetica_bold,background_color: .clear)
                return headerView
            } else {
                return nil
            }
            
        case 3:
            if self.shared_data_list_model?.address?.count ?? 0 > 0 {
                headerView.setupData(title: LocalText.PersonalDetails().address(),font: AppFont.helvetica_bold,background_color: .clear)
                return headerView
            } else {
                return nil
            }
        case 4:
            if self.shared_data_list_model?.shared_social_data?.linkedin != "" || self.shared_data_list_model?.shared_social_data?.twitter != "" {
                headerView.setupData(title: LocalText.MyProfile().social_media(),font: AppFont.helvetica_bold,background_color: .clear)
                return headerView
            } else {
                return nil
            }
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_shared_data_details_tbl_view_cell) as! SharedDataDetailsTblViewCell
        
        switch indexPath.section {
            
        case 0:
            let shared_name = indexPath.row == 0 ? "\(UserDetailsModel.shared.first_name)" : "\(UserDetailsModel.shared.last_name)"
            let shared_name_type = indexPath.row == 0 ? "\(LocalText.Profile().first_name())" : "\(LocalText.Profile().last_name())"
            let shared_data_model = SharedDataModel(type_of_value: shared_name_type,value: shared_name)
            cell.setupUI(is_right_label_hidden: false)
            cell.setupData(shared_data_model: shared_data_model)
            
        case 1:
            if self.shared_data_list_model?.mobile_number?.count ?? 0 > indexPath.row {
                if let shared_mobile_int = self.shared_data_list_model?.mobile_number?[indexPath.row],
                   self.user_profile_model.arr_mobile_numbers.count >= shared_mobile_int {
                                        
                    let shared_mobile_number = "\(self.user_profile_model.arr_mobile_numbers[shared_mobile_int - 1].country_code?.dialCode() ?? "") \(self.user_profile_model.arr_mobile_numbers[shared_mobile_int - 1].value)"
                    let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.SignUpScreen().mobile_number()) \(shared_mobile_int)",value: shared_mobile_number)
                    cell.setupUI(is_right_label_hidden: false)
                    cell.setupData(shared_data_model: shared_data_model)
                }
            }
        case 2:
            if self.shared_data_list_model?.email_id?.count ?? 0 > indexPath.row {
                if let shared_email_int = shared_data_list_model?.email_id?[indexPath.row] {
                    if self.user_profile_model.arr_email.count >= shared_email_int {
                        let shared_email = self.user_profile_model.arr_email[shared_email_int - 1].value
                        let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.MyProfile().email()) \(shared_email_int)",value: shared_email)
                        cell.setupUI(is_right_label_hidden: false)
                        cell.setupData(shared_data_model: shared_data_model)
                    }
                }
            }
        case 3:
            if self.shared_data_list_model?.address?.count ?? 0 > indexPath.row {
                if let shared_address_int = self.shared_data_list_model?.address?[indexPath.row] {
                    if self.user_profile_model.arr_address.count >= shared_address_int {
                        let shared_address = self.user_profile_model.arr_address[shared_address_int - 1].value
                        let shared_data_model = SharedDataModel(type_of_value: "\(LocalText.MyProfile().address()) \(shared_address_int)",value: shared_address)
                        cell.setupUI(is_right_label_hidden: true)
                        cell.setupData(shared_data_model: shared_data_model)
                    }
                }
            }
        case 4:
            let linked_in_url = self.shared_data_list_model?.shared_social_data?.linkedin
            let twitter_url = self.shared_data_list_model?.shared_social_data?.twitter
            cell.setupUI(is_right_label_hidden: nil)
            cell.setupData(shared_data_model: nil,linked_in_hidden: linked_in_url == "",twitter_hidden: twitter_url == "")
        default:
            cell.isHidden = true
        }
        
        return cell
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    /// Use this function filter share data list according to available data in local database
    func getAvailableSharedData(for profile_data_models : [ProfileDataModel],from shared_data : [Int]) -> [Int] {
        var new_shared_data = shared_data
        for i in ( 0..<shared_data.count ).reversed() {
            let shared_data_int = shared_data[i]
            if profile_data_models.count < shared_data_int {
                new_shared_data.remove(at: i)
            }
        }
        return new_shared_data
    }
}
