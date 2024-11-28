//
//  BlockedTblView.swift
//  AddressFull
//
//  Created by Sneh on 05/01/24.
//

import Foundation
import SDWebImage


class BlockedTblView: CustomTableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - OBJECTS & OUTLETS
    
    var did_unblock_button_pressed_block : ((_ model: OrganizationListModel) -> Void)!
    let k_blocked_organization_tbl_view_cell = BlockedOrganizationTblViewCell.identifier
    var organization_list = [OrganizationListModel]()
    
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
        
        self.register(UINib(nibName: self.k_blocked_organization_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_blocked_organization_tbl_view_cell)
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
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_blocked_organization_tbl_view_cell) as! BlockedOrganizationTblViewCell
        
        if self.organization_list.count > 0 {
            let model = self.organization_list[indexPath.row]
            
            cell.did_unblock_button_pressed_block = {
                if let did_unblock_button_pressed_block = self.did_unblock_button_pressed_block {
                    did_unblock_button_pressed_block(model)
                }
            }
            
            cell.setupUI()
            cell.setupData(model: model)
        }
        return cell
    }
}
