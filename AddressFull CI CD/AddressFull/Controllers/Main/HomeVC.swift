//
//  HomeVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class HomeVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var is_search_active = false
    let home_view_model = HomeViewModel()
    var current_page = 1
    var total_pages = 1
    var debounceTimer: Timer?
    var full_string = ""
    var vc_from_notification : UIViewController?
    var pull_to_refresh_started = false
    
    @IBOutlet weak var btn_got_to_top_trusted_organizations: BasePoppinsRegularButton!
    @IBOutlet weak var lbl_no_data: AFLabelRegular!
    @IBOutlet weak var no_data_view: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var search_background_view: UIView!
    @IBOutlet weak var img_view_search_icon: UIImageView!
    @IBOutlet weak var txt_search: BaseTextfield!
    @IBOutlet weak var search_separator_view: UIView!
    @IBOutlet weak var view_request_separator_view: UIView!
    @IBOutlet weak var view_request: UIView!
    @IBOutlet weak var view_shared_data: UIView!
    //    @IBOutlet weak var img_request: UIImageView!
    @IBOutlet weak var lbl_request: AFLabelRegular!
    @IBOutlet weak var btn_shared_data_count: UIButton!
    @IBOutlet weak var img_shared_data: UIImageView!
    @IBOutlet weak var btn_request_count: UIButton!
    @IBOutlet weak var lbl_shared_data: AFLabelRegular!
    @IBOutlet weak var tbl_view_my_trusted_organization: TopTrustedOrganizationTBLView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_trusted_organizations(),isWithBackOption: false,{
            self.navigateTo(.profile_vc(is_from_login: false))
        })
        self.setupRequest()
        GlobalVariables.shared.is_app_launched = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_my_trusted_organization.refresh_control.beginRefreshing()
                self.tbl_view_my_trusted_organization.setContentOffset(CGPointMake(0, -self.tbl_view_my_trusted_organization.refresh_control.bounds.size.height), animated: false)
                self.tbl_view_my_trusted_organization.isScrollEnabled = false
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_my_trusted_organization.refresh_control.endRefreshing()
                self.tbl_view_my_trusted_organization.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    override func refreshViaDataSyncNotification(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_trusted_organizations(),isWithBackOption: false,{
                self.navigateTo(.profile_vc(is_from_login: false))
            })
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.navigateToControllerFromNotification()
        self.localTextSetup()
        self.setUpSearchTextField()
        self.getMyTrustedOrganizationList()
        self.manageRequestCount(model: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViaNotification), name: Notification.Name(NotificationName.reload_home_vc), object: nil)
    }
    
    func navigateToControllerFromNotification() {
        if let vc_from_notification = GlobalVariables.shared.vc_from_notification , !(vc_from_notification is HomeVC) {
            DispatchQueue.main.async {
                vc_from_notification.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc_from_notification, animated: false)
                GlobalVariables.shared.vc_from_notification = nil
            }
        }
    }
    
    func setUpSearchTextField() {
        self.search_background_view.setupLayer(borderColor: .clear, borderWidth: 1.0, cornerRadius: 14.0)
        self.txt_search.set(strFont: AppFont.helvetica_regular)
        self.txt_search.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.txt_search.didShouldChangeCharactersInTextfieldBlock = { (textField, full_string) in
            self.debounceTimer?.invalidate()
            self.debounceTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.callMytrustedApi), userInfo: nil, repeats: false)
            self.is_search_active = full_string.count > 0
            self.full_string = full_string.trimmingCharacters(in: .whitespaces)
            self.current_page = 1
        }
    }
    
    func setupRequest() {
        self.view_request.setCorner(radius: 14, toCorners: .allCorners)
        self.view_shared_data.setCorner(radius: 14, toCorners: .allCorners)
        self.view_request.backgroundColor = AppColor.primary_green().withAlphaComponent(0.15)
        self.view_shared_data.backgroundColor = AppColor.primary_green().withAlphaComponent(0.15)
        
        //        self.btn_request_count.makeRounded()
        //        self.btn_shared_data_count.makeRounded()
        //        self.btn_request_count.backgroundColor = AppColor.primary_red()
        //        self.btn_shared_data_count.backgroundColor = AppColor.primary_red()
        //        self.btn_request_count.layer.borderWidth = 1
        //        self.btn_request_count.layer.borderColor = UIColor.white.cgColor
        //        self.btn_shared_data_count.layer.borderWidth = 1
        //        self.btn_shared_data_count.layer.borderColor = UIColor.white.cgColor
        self.btn_request_count.setTitleColor(AppColor.primary_green(), for: .normal)
        self.btn_shared_data_count.setTitleColor(AppColor.primary_green(), for: .normal)
        
        self.lbl_request.text = LocalText.Home().new_requests()
        self.lbl_shared_data.text = LocalText.Home().shared_data()
        self.lbl_request.textColor = .black
        self.lbl_shared_data.textColor = .black
        
        self.btn_got_to_top_trusted_organizations.setStyle(withClearBackground: true)
        self.btn_got_to_top_trusted_organizations.setupLayer(borderColor: AppColor.primary_green(), borderWidth: 1, cornerRadius: 20)
        self.btn_got_to_top_trusted_organizations.setTitle(LocalText.Onboarding().get_started(), for: .normal)
    }
    
    func localTextSetup() {
        self.txt_search.placeholder = LocalText.Home().search_organization()
        self.lbl_no_data.setAttributedStringWithLineSpacing(str: LocalText.Home().its_time_to_start_connecting(), spacing: 10)
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewTrustedOrganizationSetup() {
        
        self.tbl_view_my_trusted_organization.header_view_title = self.is_search_active ? LocalText.TrustedOrganization().search_result() : LocalText.Home().my_trusted_organizations()
        
        self.tbl_view_my_trusted_organization.is_my_trusted = true
        
        self.tbl_view_my_trusted_organization.did_more_button_pressed_block = { index in
            self.navigateTo(.organization_more_option_vc(
                organization_model: self.tbl_view_my_trusted_organization.organization_list[index],
                is_from_notification: false,
                button_titles: [
                    LocalText.OrganizationMoreOptions().view_shared_data(),
                    LocalText.OrganizationMoreOptions().delete_organization(),
                    LocalText.OrganizationMoreOptions().block_organization()],
                block_completion: nil
            ))
        }
        
        self.tbl_view_my_trusted_organization.did_organization_selected_block = { index in
            
            if let id = self.tbl_view_my_trusted_organization.organization_list[index].organizationId {
                self.navigateTo(.organization_profile(id: id))
            }
        }
        
        self.tbl_view_my_trusted_organization.addPullRefresh()
        
        self.tbl_view_my_trusted_organization.pull_to_refresh_block = {
            self.current_page = 1
            self.getMyTrustedOrganizationList(searchText: self.txt_search.text ?? "",is_pull_to_refresh: true)
            self.pull_to_refresh_started = true
        }
        
        self.tbl_view_my_trusted_organization.pagination_block =  {
            if self.current_page < self.total_pages {
                self.tbl_view_my_trusted_organization.showLoadingIndicatorInFooter()
                self.current_page += 1
                self.getMyTrustedOrganizationList(searchText: self.txt_search.text ?? "",is_pull_to_refresh: false)
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_view_my_trusted_organization.reloadData()
        }
    }
    
    func manageRequestCount(model: OrganizationListBaseModel?) {
        DispatchQueue.main.async {
            //            if let request_count = model?.data?.request_count, request_count > 0 {
            //                self.btn_request_count.isHidden = false
            self.btn_request_count.setTitle("\(model?.data?.request_count ?? 0)", for: .normal)
            self.btn_request_count.titleLabel?.font = UIFont(name: AppFont.helvetica_bold, size: 24)
            //            } else {
            //                self.btn_request_count.isHidden = true
            //            }
            
            //            if let shared_count = model?.data?.shared_count, shared_count > 0 {
            //                self.btn_shared_data_count.isHidden = false
            self.btn_shared_data_count.setTitle("\(model?.data?.shared_count ?? 0)", for: .normal)
            self.btn_shared_data_count.titleLabel?.font = UIFont(name: AppFont.helvetica_bold, size: 24)
            //            } else {
            //                self.btn_shared_data_count.isHidden = true
            //            }
        }
    }
    
    func managebackButton() {
        if self.full_string == "" {
            
            self.is_search_active = false
            
            DispatchQueue.main.async {
                self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_trusted_organizations(),isWithBackOption: false,{
                    self.navigateTo(.profile_vc(is_from_login: false))
                })
            }
        } else {
            DispatchQueue.main.async {
                self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_trusted_organizations(),isWithBackOption: true,{
                    
                    self.is_search_active = false
                    self.txt_search.text = ""
                    self.getMyTrustedOrganizationList()
                    
                    self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_trusted_organizations(),isWithBackOption: false,{
                        self.navigateTo(.profile_vc(is_from_login: false))
                    })
                    
                })
            }
        }
    }
    
    // MARK: - OBJC FUNCTION
    
    @objc func refreshViaNotification() {
        self.txt_search.text = ""
        self.full_string = ""
        self.callMytrustedApi()
    }
    
    @objc func callMytrustedApi() {
        self.managebackButton()
        self.getMyTrustedOrganizationList(searchText: self.full_string)
    }
    
    
    // MARK: - API CALL
    
    func getMyTrustedOrganizationList(searchText: String = "" ,is_pull_to_refresh : Bool? = nil) {
        
        self.tbl_view_my_trusted_organization.isScrollEnabled = !(is_pull_to_refresh ?? false)
        
        self.home_view_model.getMyTrustedOrganizationApiCall(search: searchText,
                                                             currentPage: self.current_page,
                                                             view_for_progress_indicator: self.tbl_view_my_trusted_organization,
                                                             is_pull_to_refresh: is_pull_to_refresh != nil)
        { is_success, model, _ in
            
            if is_success, let list = model?.data?.organization_list , list.count > 0 {
                
                self.total_pages = model?.data?.page_info?.total_pages ?? 1
                
                if self.current_page == 1 {
                    self.tbl_view_my_trusted_organization.organization_list = list
                } else {
                    self.tbl_view_my_trusted_organization.organization_list.append(contentsOf: list)
                }
                
                DispatchQueue.main.async {
                    self.no_data_view.isHidden = true
                    self.tbl_view_my_trusted_organization.hideNoDataLabel()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.no_data_view.isHidden = false
                    self.tbl_view_my_trusted_organization.hideNoDataLabel()
                    self.lbl_no_data.setAttributedStringWithLineSpacing(str: searchText == "" ? LocalText.Home().its_time_to_start_connecting() : LocalText.Home().no_organization_found(), spacing: 10)
                    
                }
                self.tbl_view_my_trusted_organization.organization_list = []
            }
            
            self.manageRequestCount(model: model)
            self.tblViewTrustedOrganizationSetup()
            self.tbl_view_my_trusted_organization.hideLoadingIndicatorInFooter()
            self.tbl_view_my_trusted_organization.hidePullToRefresh()
            self.tbl_view_my_trusted_organization.isScrollEnabled = true
            self.pull_to_refresh_started = false
            
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnRequestPressed(_ sender: UIButton) {
        if GlobalVariables.shared.sync_data_completed {
            self.navigateTo(.request_vc)
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
    
    @IBAction func btnSharedDataPressed(_ sender: UIButton) {
        if GlobalVariables.shared.sync_data_completed {
            self.navigateTo(.shared_data_vc)
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
    
    @IBAction func btnTopTrustedOrganizationPressed(_ sender: BasePoppinsRegularButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
}
