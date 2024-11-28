//
//  AppLockTblView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 07/11/23.
//

import UIKit

class AppLockTblView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let k_single_label_checkmark_tbl_view_cell = SingleLabelCheckmarkTblViewCell.identifier
    let k_single_label_tbl_view_cell = SingleLabelTblViewCell.identifier
    var did_option_selected_block: ((_ option: String) -> Void)!
    var app_lock = AppLockBaseModel()
    var is_for_notification = false
    var arr_auto_lock_delay_in_seconds = [30,60,120,300]
    
    
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
           
        self.register(UINib(nibName: self.k_single_label_checkmark_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_single_label_checkmark_tbl_view_cell)
        
        self.register(UINib(nibName: self.k_single_label_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_single_label_tbl_view_cell)
    }
    
    
    
    
    // MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.app_lock.model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.app_lock.model[section].options.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UtilityManager().getPropotionalHeight(baseHeight: 812, height: 50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_view = Bundle.main.loadNibNamed(SingleLabelTblViewHeader.identifier, owner: self)![0] as! SingleLabelTblViewHeader
        header_view.setupData(title: self.app_lock.model[section].header_title)
        return header_view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UtilityManager().getPropotionalHeight(baseHeight: 812, height: 55)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_single_label_checkmark_tbl_view_cell) as! SingleLabelCheckmarkTblViewCell
        
        cell.setupUI(is_for_notification: self.is_for_notification)
        cell.dataSetup(model: self.app_lock.model[indexPath.section].options[indexPath.row])
        
        
        // FOR APP LOCK SETTINGS
        cell.did_select_app_lock_block = {
            
            // RESET ALL VALUES
            self.app_lock.model[indexPath.section].options = self.app_lock.model[indexPath.section].options.map { model in
                var updatedModel = model
                updatedModel.is_selected = false
                return updatedModel }
            
            // SET VALUE TO TRUE AND SAVE
            self.app_lock.model[indexPath.section].options[indexPath.row].is_selected = true
            UserDefaults.standard.set(self.arr_auto_lock_delay_in_seconds[indexPath.row], forKey: UserDefaultsKey.app_lock_duration)
            
            // START TIMER
            AutoLock.shared.startInactivityTimer()
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        
        // SWITCH VALUE CHANGED (FOR NOTIFICATION SETTINGS)
        cell.did_switch_value_changed_block = {
            self.app_lock.model[indexPath.section].options[indexPath.row].is_selected = !self.app_lock.model[indexPath.section].options[indexPath.row].is_selected
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        return cell
    }
}
