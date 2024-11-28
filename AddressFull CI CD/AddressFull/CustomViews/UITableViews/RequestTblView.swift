//
//  RequestTblView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit
import SDWebImage

class RequestTblView: CustomTableView, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_view_requests_tbl_view_cell = RequestTblCell.identifier
    var request_list = [RequestListResponseModel]()
    var button_accept_pressed_block : ((Int) -> Void)?
    var button_reject_pressed_block : ((Int) -> Void)?
    
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
        self.register(UINib(nibName: self.k_view_requests_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_view_requests_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.request_list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_view_requests_tbl_view_cell) as! RequestTblCell
        
        let request_model = self.request_list[indexPath.row]
        
        cell.button_accept_pressed_block = {
            if let button_accept_pressed_block = self.button_accept_pressed_block {
                button_accept_pressed_block(indexPath.row)
            }
        }
        
        cell.button_reject_pressed_block = {
            if let button_reject_pressed_block = self.button_reject_pressed_block {
                button_reject_pressed_block(indexPath.row)
            }
        }
        
        cell.setUpData(model: request_model)
        
        return cell
    }
}
