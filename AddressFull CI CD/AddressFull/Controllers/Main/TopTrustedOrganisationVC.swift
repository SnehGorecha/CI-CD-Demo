//
//  TopTrustedOrganisationVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class TopTrustedOrganisationVC: BaseViewController {
    
    //MARK: - OBJECTS & OUTLETS
    
    var is_search_active = false
    let top_trusted_organization_view_model = TopTrustedOrganizationViewModel()
    let refreshControl = UIRefreshControl()
    var current_page = 1
    var total_pages = 1
    var debounceTimer: Timer?
    var full_string = ""
    var pull_to_refresh_started = false
    
    @IBOutlet weak var view_search_textfield: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var txt_search_organization: BaseTextfield!
    @IBOutlet weak var search_organization_separator_view: UIView!
    @IBOutlet weak var tbl_view_top_trusted_organization: TopTrustedOrganizationTBLView!
    
    
    //MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.TrustedOrganization().top_trusted_organization(),isWithBackOption: false,{
            self.navigateTo(.profile_vc(is_from_login: false))
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_top_trusted_organization.refresh_control.beginRefreshing()
                self.tbl_view_top_trusted_organization.setContentOffset(CGPointMake(0, -self.tbl_view_top_trusted_organization.refresh_control.bounds.size.height), animated: false)
                self.tbl_view_top_trusted_organization.isScrollEnabled = false
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_top_trusted_organization.refresh_control.endRefreshing()
                self.tbl_view_top_trusted_organization.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    override func refreshViaDataSyncNotification(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.navigation_bar.navigationBarSetup(title: LocalText.TrustedOrganization().top_trusted_organization(),isWithBackOption: false,{
                self.navigateTo(.profile_vc(is_from_login: false))
            })
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.localTextSetup()
        self.setUpSearchTextField()
        self.getTopTrustedOrganizationList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViaNotification), name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil)
    }
    
    func localTextSetup() {
        self.txt_search_organization.placeholder = LocalText.Home().search_organization()
    }
    
    func setUpSearchTextField() {
        self.view_search_textfield.setupLayer(cornerRadius: 14)
        self.txt_search_organization.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.txt_search_organization.set(strFont: AppFont.helvetica_regular)
        self.txt_search_organization.didShouldChangeCharactersInTextfieldBlock = { (textField, full_string) in
            self.debounceTimer?.invalidate()
            self.debounceTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.callToptrustedApi), userInfo: nil, repeats: false)
            self.is_search_active = full_string.count > 0
            self.full_string = full_string.trimmingCharacters(in: .whitespaces)
            self.current_page = 1
        }
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewTrustedOrganizationSetup() {
    
        self.tbl_view_top_trusted_organization.header_view_title = self.is_search_active ? LocalText.TrustedOrganization().search_result() : LocalText.TrustedOrganization().top_trusted_organization()
        
        self.tbl_view_top_trusted_organization.did_organization_selected_block = { index in
            
            if let id = self.tbl_view_top_trusted_organization.organization_list[index].id {
                self.navigateTo(.organization_profile(id: id))
            }
        }
        
        self.tbl_view_top_trusted_organization.addPullRefresh()
        
        self.tbl_view_top_trusted_organization.pull_to_refresh_block = {
            self.current_page = 1
            self.getTopTrustedOrganizationList(searchText: self.txt_search_organization.text ?? "",is_pull_to_refresh: true)
            self.pull_to_refresh_started = true
        }
        
        self.tbl_view_top_trusted_organization.pagination_block =  {
            if self.current_page < self.total_pages {
                self.tbl_view_top_trusted_organization.showLoadingIndicatorInFooter()
                self.current_page += 1
                self.getTopTrustedOrganizationList(searchText: self.txt_search_organization.text ?? "",is_pull_to_refresh: false)
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_view_top_trusted_organization.reloadData()
        }
    }
    
    func managebackButton() {
        
        if self.full_string == "" {
            
            self.is_search_active = false
            
            DispatchQueue.main.async {
                self.navigation_bar.navigationBarSetup(title: LocalText.TrustedOrganization().top_trusted_organization(),isWithBackOption: false,{
                    self.navigateTo(.profile_vc(is_from_login: false))
                })
            }
            
        } else {
            DispatchQueue.main.async {
                self.navigation_bar.navigationBarSetup(title: LocalText.TrustedOrganization().top_trusted_organization(),isWithBackOption: true,{
                    
                    self.txt_search_organization.text = ""
                    self.is_search_active = false
                    self.getTopTrustedOrganizationList()
                    
                    self.navigation_bar.navigationBarSetup(title: LocalText.TrustedOrganization().top_trusted_organization(),isWithBackOption: false,{
                        self.navigateTo(.profile_vc(is_from_login: false))
                    })
                })
            }
        }
    }
    
    
    // MARK: OBJC FUNCTION
    
    @objc func refreshViaNotification() {
        self.txt_search_organization.text = ""
        self.full_string = ""
        self.callToptrustedApi()
    }
    
    @objc func callToptrustedApi() {
        self.managebackButton()
        self.getTopTrustedOrganizationList(searchText: self.full_string)
    }
    

    // MARK: API CALL
    
    func getTopTrustedOrganizationList(searchText: String = "",is_pull_to_refresh: Bool? = nil) {
        
        self.tbl_view_top_trusted_organization.isScrollEnabled = !(is_pull_to_refresh ?? false)
        
        self.top_trusted_organization_view_model.getTopTrustedOrganizationApiCall(
            search: searchText,
            currentPage: self.current_page,
            view_for_progress_indicator: self.tbl_view_top_trusted_organization,
            is_pull_to_refresh: is_pull_to_refresh != nil)
        { is_success, model in
            
            if is_success, let list = model?.data?.organization_list , list.count > 0 {
                
                self.total_pages = model?.data?.page_info?.total_pages ?? 1
                
                if self.current_page == 1 {
                    self.tbl_view_top_trusted_organization.organization_list = list
                } else {
                    self.tbl_view_top_trusted_organization.organization_list.append(contentsOf: list)
                }
                
                self.tbl_view_top_trusted_organization.hideNoDataLabel()
                
            } else {
                self.tbl_view_top_trusted_organization.showNoDataLabel(is_for_search: searchText != "")
                self.tbl_view_top_trusted_organization.organization_list = []
            }
            
            self.tblViewTrustedOrganizationSetup()
            self.tbl_view_top_trusted_organization.hideLoadingIndicatorInFooter()
            self.tbl_view_top_trusted_organization.hidePullToRefresh()
            self.tbl_view_top_trusted_organization.isScrollEnabled = true
            self.pull_to_refresh_started = false
        }
    }
    
}
