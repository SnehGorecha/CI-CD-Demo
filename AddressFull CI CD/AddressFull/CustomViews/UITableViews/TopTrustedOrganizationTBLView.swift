//
//  TopTrustedOrganizationTBLView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit
import SDWebImage


class TopTrustedOrganizationTBLView: CustomTableView, UITableViewDelegate, UITableViewDataSource {
    

    // MARK: - OBJECTS & OUTLETS
    
    var did_more_button_pressed_block : ((_ index: Int) -> Void)!
    var did_organization_selected_block : ((_ index: Int) -> Void)!
    var did_scroll_to_bottom_block : (() -> Void)!
    let k_top_trusted_organization_tbl_view_cell = TopTrustedOrganizationTBLViewCell.identifier
    var header_view_title = ""
    var is_my_trusted = false
    var organization_list = [OrganizationListModel]()
    var loading_indicator = UIActivityIndicatorView(style: .medium)
    
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
        
        self.register(UINib(nibName: self.k_top_trusted_organization_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_top_trusted_organization_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.organization_list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
//        return UtilityManager().getPropotionalHeight(baseHeight: 812, height: self.is_my_trusted
//                                                                                ? self.organization_list.count > 0
//                                                                                    ? 60
//                                                                                        : 0
//                                                                                            : 60)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header_view = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
        header_view.setupData(title: self.header_view_title)
        header_view.backgroundColor = AppColor.light_gray()
        return header_view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_top_trusted_organization_tbl_view_cell) as! TopTrustedOrganizationTBLViewCell
        
        if self.organization_list.count > 0 {
            let model = self.organization_list[indexPath.row]
            
            cell.did_more_button_pressed_block = {
                if let did_more_button_pressed_block = self.did_more_button_pressed_block , GlobalVariables.shared.sync_data_completed {
                    did_more_button_pressed_block(indexPath.row)
                } else {
                    UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
                }
            }
            
            cell.setupUI()
            cell.setupData(model: model, is_my_trusted: self.is_my_trusted)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let did_organization_selected_block = self.did_organization_selected_block , GlobalVariables.shared.sync_data_completed {
            did_organization_selected_block(indexPath.row)
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
}
