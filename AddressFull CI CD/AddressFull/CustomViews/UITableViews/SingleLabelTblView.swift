//
//  SettingsTblView.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import UIKit

class SingleLabelTblView: UITableView, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: - OBJECTS & OUTLETS
    
    var did_option_selected_block: ((_ option: String, _ selected_index: Int) -> Void)!
    let k_single_label_tbl_view_cell = SingleLabelTblViewCell.identifier
    var name_list = [String]()
    var icon_list = [String]()
    var header_footer_corner_radius: Double? = nil
    var bg_color: UIColor = .clear
    var row_height: CGFloat?
    
    // MARK: - TABLE VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.removeHeaderTopPadding()
        
        self.delegate = self
        self.dataSource = self
        self.estimatedRowHeight = 38.0
        self.rowHeight = UITableView.automaticDimension
        self.register(UINib(nibName: self.k_single_label_tbl_view_cell, bundle: nil), forCellReuseIdentifier: self.k_single_label_tbl_view_cell)
    }
    
    
    // MARK: - TABLE VIEW DELEGATE & DATA SOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header_view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16.0))
                
        if let radius = self.header_footer_corner_radius {
            header_view.setCorner(radius: radius, toCorners: [.topLeft, .topRight])
        }
        
        return header_view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.header_footer_corner_radius == nil ? 0.01 : 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if let radius = self.header_footer_corner_radius {
            let footer_view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16.0))
            
            footer_view.setCorner(radius: radius, toCorners: [.bottomLeft, .bottomRight])
            
            return footer_view
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (row_height != nil) ? row_height ?? 40.0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.k_single_label_tbl_view_cell) as! SingleLabelTblViewCell
        
        cell.setupUI(textAlignment: .left,
                     withLeadingAndTrailinfSpcae: !(self.header_footer_corner_radius == nil),
                     is_icon_hidden: false,
                     bg_color: bg_color)
       
        if icon_list.count > 0 {
            cell.dataSetup(self.name_list[indexPath.row],self.icon_list[indexPath.row])
        } else {
            cell.dataSetup(self.name_list[indexPath.row])
        }
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.did_option_selected_block != nil , GlobalVariables.shared.sync_data_completed {
            self.did_option_selected_block(self.name_list[indexPath.row], indexPath.row)
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
}
