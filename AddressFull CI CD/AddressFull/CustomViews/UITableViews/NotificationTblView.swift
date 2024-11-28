//
//  NotificationTblView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 03/11/23.
//

import UIKit

class NotificationTblView: CustomTableView, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var didBtnMorePressedBlock : ((_ row: Int, _ section: Int) -> Void)!
    let k_notification_tbl_view_cell = NotificationTblViewCell.identifier
    var notification_list = [ActivityLogResultModel]()
    
    var is_for_notification = false
    
    
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
        self.register(UINib(nibName: self.k_notification_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_notification_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.is_for_notification ? 1 : self.notification_list.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_notification_tbl_view_cell) as! NotificationTblViewCell
        
        cell.view_btn_more.isHidden = !self.is_for_notification
        
        cell.didMorePressedBlock = { (row, section) in
            if self.didBtnMorePressedBlock != nil {
                self.didBtnMorePressedBlock(row, section)
            }
        }
        
        if self.is_for_notification {
            cell.setupData(organization_profile_picture: nil, message: "Amazon requested to access your Address.", date: "18-09-2023, 02:24 pm")
        } else {
            if indexPath.row < self.notification_list.count {
                let model = self.notification_list[indexPath.row]
                cell.setupData(organization_profile_picture: model.organization_logo, message: model.message ?? "", date: model.created_date ?? "")
            }
        }
        
        return cell
    }
}
