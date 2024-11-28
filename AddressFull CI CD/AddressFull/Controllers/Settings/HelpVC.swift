//
//  HelpVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 06/11/23.
//

import UIKit

class HelpVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var options_name_list = [
        LocalText.Help().help_center(),
        LocalText.Help().contact_us(),
        LocalText.Help().terms_and_privacy_policy(),
        LocalText.Help().app_info(),
        LocalText.Help().disclaimer()
    ]
    
    var icon_list = [
        AssetsImage.help_filled,
        AssetsImage.contact,
        AssetsImage.terms,
        AssetsImage.information_filled,
        AssetsImage.exclaimation
    ]
    
    var web_view_url_list = [
        WebviewUrl.Help.help_center,
        WebviewUrl.Help.contact_us,
        WebviewUrl.Help.terms_and_privacy_policy,
        WebviewUrl.Help.app_info
    ]
    
    var is_for_data_protection_policy = false
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_help_list: SingleLabelTblView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: self.is_for_data_protection_policy ? LocalText.Settings().data_protection() : LocalText.Help().help(),
                                               isWithBackOption: true)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.setData()
        self.tblViewSettingSetup()
    }
    
    func setData() {
        if self.is_for_data_protection_policy {
            
            self.options_name_list = [
                LocalText.Settings().gdpr_policy(),
                LocalText.Settings().popia_policy(),
                LocalText.DataSubjectAccessRequest().dsar_description_title()
            ]
            
            self.icon_list = [
                AssetsImage.gdpr_policy,
                AssetsImage.popia_policy,
                AssetsImage.data_protection_policy
            ]
            
        } else {
            self.options_name_list = [
                LocalText.Help().help_center(),
                LocalText.Help().contact_us(),
                LocalText.Help().terms_and_privacy_policy(),
                LocalText.Help().app_info()
//                LocalText.Help().disclaimer()
            ]
            
            self.icon_list = [
                AssetsImage.help_filled,
                AssetsImage.contact,
                AssetsImage.terms,
                AssetsImage.information_filled
//                AssetsImage.exclaimation
            ]
        }
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewSettingSetup() {
        self.tbl_view_help_list.name_list = self.options_name_list
        self.tbl_view_help_list.icon_list = self.icon_list
        self.tbl_view_help_list.bg_color = .white
        self.tbl_view_help_list.row_height = UtilityManager().getPropotionalHeight(baseHeight: 812, height: 60)
        self.tbl_view_help_list.reloadData()
        
        self.tbl_view_help_list.did_option_selected_block = { (option, selected_index) in
            
            if self.is_for_data_protection_policy {
                
                if selected_index == 0 {
                    
                    self.navigateTo(.gdpr_compliance_vc(is_from_login: false))
                    
                } else if selected_index == 1 {
                    
                    self.navigateTo(.gdpr_compliance_vc(is_from_login: false,is_for_popia: true))
                    
                } else if selected_index == 2 {
                    
                    self.navigateTo(.data_subject_access_request_vc)
                    
                }
                
            } else {
                
                self.navigateTo(.web_view_vc(title: self.options_name_list[selected_index], web_view_url: self.web_view_url_list[selected_index]))
                
            }
        }
    }
}
