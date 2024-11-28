//
//  BlockVC.swift
//  AddressFull
//
//  Created by Sneh on 05/01/24.
//

import UIKit

class BlockVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    let blocked_organization_view_model = BlockedOrganizationViewModel()
    var current_page = 1
    var total_pages = 1
    var debounceTimer: Timer?
    var full_string = ""
    
    @IBOutlet weak var tbl_view_blocked_organization: BlockedTblView!
    @IBOutlet weak var view_search_textfield: UIView!
    @IBOutlet weak var txt_search_organization: BaseTextfield!
    @IBOutlet weak var navigation_bar: UIView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Settings().blocked(),
                                               isWithBackOption: true)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.localTextSetup()
        self.setUpSearchTextField()
        self.getBlockOrganizationList()
    }
    
    func localTextSetup() {
        self.txt_search_organization.placeholder = LocalText.Home().search_organization()
    }
    
    func setUpSearchTextField() {
        self.view_search_textfield.setupLayer(borderColor: .clear, borderWidth: 1.0, cornerRadius: 14.0)
        self.txt_search_organization.set(strFont: AppFont.helvetica_regular)
        self.txt_search_organization.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.txt_search_organization.didShouldChangeCharactersInTextfieldBlock = { (textField, full_string) in
            self.debounceTimer?.invalidate()
            self.debounceTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.callBlockedApi), userInfo: nil, repeats: false)
            self.full_string = full_string.trimmingCharacters(in: .whitespaces)
            self.current_page = 1
        }
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewBlockedOrganizationSetup() {
        
        self.tbl_view_blocked_organization.did_unblock_button_pressed_block = { model in
            if let id = model.organizationId {
                self.unBlockOrganization(organization_id: id)
            }
        }
        
        self.tbl_view_blocked_organization.addPullRefresh()
        
        self.tbl_view_blocked_organization.pull_to_refresh_block = {
            self.current_page = 1
            self.getBlockOrganizationList(searchText: self.txt_search_organization.text ?? "",is_pull_to_refresh: true)
        }
        
        self.tbl_view_blocked_organization.pagination_block =  {
            if self.current_page < self.total_pages {
                self.tbl_view_blocked_organization.showLoadingIndicatorInFooter()
                self.current_page += 1
                self.getBlockOrganizationList(searchText: self.txt_search_organization.text ?? "",is_pull_to_refresh: false)
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_view_blocked_organization.reloadData()
        }
    }
    
    
    // MARK: - OBJC FUNCTION
    
    @objc func callBlockedApi() {
        self.getBlockOrganizationList(searchText: self.full_string)
    }
    
    @objc func pullToRefreshCalled() {
        self.current_page = 1
        self.getBlockOrganizationList(is_pull_to_refresh: true)
    }
    
    
    // MARK: - API CALL
    
    func getBlockOrganizationList(searchText: String = "",
                                  is_pull_to_refresh: Bool? = nil) {
        
        self.tbl_view_blocked_organization.isScrollEnabled = !(is_pull_to_refresh ?? false)
        
        self.blocked_organization_view_model.getBlockedOrganizationApiCall(search: searchText,
                                                                           currentPage: self.current_page,
                                                                           view_for_progress_indicator: self.tbl_view_blocked_organization,
                                                                           is_pull_to_refresh: is_pull_to_refresh != nil)
        { is_success, model, error_message in
            
            if is_success, let list = model?.data?.organization_list , list.count > 0 {
                
                self.total_pages = model?.data?.page_info?.total_pages ?? 1
                
                if self.current_page == 1 {
                    self.tbl_view_blocked_organization.organization_list = list
                } else {
                    self.tbl_view_blocked_organization.organization_list.append(contentsOf: list)
                }
                
                self.tbl_view_blocked_organization.hideNoDataLabel()
                
            } else {
                self.tbl_view_blocked_organization.showNoDataLabel(is_for_search: searchText != "")
                self.tbl_view_blocked_organization.organization_list = []
            }
            
            self.tblViewBlockedOrganizationSetup()
            self.tbl_view_blocked_organization.hideLoadingIndicatorInFooter()
            self.tbl_view_blocked_organization.hidePullToRefresh()
            self.tbl_view_blocked_organization.isScrollEnabled = true
            
        }
    }
    
    
    func unBlockOrganization(organization_id : String) {
        self.blocked_organization_view_model.blockUnblockOrganizationApiCall(organization_id: organization_id, 
                                                                             block: false,
                                                                             reason: nil,
                                                                             view_for_progress_indicator: self.view, 
                                                                             completionHandler: { is_success in
            
            self.getBlockOrganizationList()
            
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil, userInfo: nil)
        })
    }
    
}
