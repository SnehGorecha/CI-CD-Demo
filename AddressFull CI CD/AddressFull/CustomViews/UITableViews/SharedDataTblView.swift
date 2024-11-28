//
//  SharedDataTblView.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation
import UIKit


class SharedDataTblView : CustomTableView , UITableViewDelegate , UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_shared_data_tbl_view_cell = SharedDataTblViewCell.identifier
    var header_view_title = ""
    var shared_data_list = [SharedDataListModel]()

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
        self.estimatedRowHeight = 100.0
        self.rowHeight = UITableView.automaticDimension
        self.addNoDataLabel()
        self.register(UINib(nibName: self.k_shared_data_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_shared_data_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shared_data_list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_shared_data_tbl_view_cell) as! SharedDataTblViewCell
        
        let shared_data_list_model = self.shared_data_list[indexPath.row]
        
        cell.setupUI()
        cell.setupData(shared_data_list_model: shared_data_list_model, user_profile_model: self.user_profile_model)

        return cell
    }
}
