//
//  SharedDataVC.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import UIKit

class SharedDataVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var is_search_active = false
    let my_profile_view_model = ProfileViewModel()
    let home_view_model = HomeViewModel()
    let refreshControl = UIRefreshControl()
    var current_page = 1
    var total_pages = 1
    var debounceTimer: Timer?
    var full_string = ""
    var shared_data_list = [SharedDataListModel]()
    
    var user_profile_model = PersonalDetailsModel(
        first_name: ProfileDataModel(type_of_field: LocalText.Profile().first_name(),
                                     type_of_value: LocalText.Profile().first_name(),
                                     value: ""),
        last_name: ProfileDataModel(type_of_field: LocalText.Profile().last_name(),
                                    type_of_value: LocalText.Profile().last_name(),
                                    value: ""),
        image: Data(),
        arr_mobile_numbers: [ProfileDataModel(
            type_of_field: LocalText.PersonalDetails().mobile_number(),
            type_of_value: LocalText.PersonalDetails().primary(),
            value: UserDetailsModel.shared.mobile_number,
            country_code: Country.getCurrentCountry()?.code)],
        arr_email: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(),
                                     type_of_value: LocalText.PersonalDetails().primary(),
                                     value: "")],
        arr_address: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(),
                                       type_of_value: LocalText.PersonalDetails().home(),
                                       value: "")],
        arr_social_links: [ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                            type_of_value: LocalText.PersonalDetails().linkedin(),
                                            value: ""),
                           ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                            type_of_value: LocalText.PersonalDetails().twitter(),
                                            value: "")]
    )
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var search_separator_view: UIView!
    @IBOutlet weak var tbl_view_shared_data: SharedDataTblView!
    @IBOutlet weak var txt_search: BaseTextfield!
    @IBOutlet weak var img_view_search_icon: UIImageView!
    @IBOutlet weak var search_background_view: UIView!

    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Home().my_shared_details(),
                                               isWithBackOption: true)
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.localTextSetup()
        self.retrivePersonalUserDetails()
        self.getMyTrustedOrganizationList()
        self.tblViewSharedDataSetup()
        self.setUpSearchTextField()
    }
    
    func localTextSetup() {
        self.txt_search.placeholder = LocalText.Home().search_organization()
    }
    
    func setUpSearchTextField() {
        self.search_background_view.setupLayer(borderColor: .clear, borderWidth: 1.0, cornerRadius: 14.0)
        self.txt_search.set(strFont: AppFont.helvetica_regular)
        self.txt_search.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.txt_search.didShouldChangeCharactersInTextfieldBlock = { (textField, full_string) in
            self.debounceTimer?.invalidate()
            self.debounceTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.callMytrustedApi), userInfo: nil, repeats: false)
            self.full_string = full_string.trimmingCharacters(in: .whitespaces)
            self.current_page = 1
        }
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewSharedDataSetup() {

        self.tbl_view_shared_data.addPullRefresh()
        
        self.tbl_view_shared_data.pull_to_refresh_block = {
            self.current_page = 1
            self.getMyTrustedOrganizationList(searchText: self.txt_search.text ?? "",is_pull_to_refresh: true)
        }
        
        self.tbl_view_shared_data.pagination_block =  {
            if self.current_page < self.total_pages {
                self.tbl_view_shared_data.showLoadingIndicatorInFooter()
                self.current_page += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.getMyTrustedOrganizationList(searchText: self.txt_search.text ?? "",is_pull_to_refresh: true)
                })
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_view_shared_data.reloadData()
        }
    }
    
    
    func retrivePersonalUserDetails() {
        if let data = self.my_profile_view_model.retrieveLoggedUserPersonalDetails(country_code: UserDetailsModel.shared.country_code, mobile_number: UserDetailsModel.shared.mobile_number) {
            self.user_profile_model = data
        }
        
        self.tbl_view_shared_data.user_profile_model = self.user_profile_model
    }
    
    // MARK: - OBJC FUNCTIONS
    
    @objc func callMytrustedApi() {
        AlamofireAPICallManager.shared.disconnectAllApi()
        self.getMyTrustedOrganizationList(searchText: self.full_string)
    }
    
    // MARK: - API CALL
    
    func getMyTrustedOrganizationList(searchText: String = "" ,is_pull_to_refresh : Bool  = false) {
        
        self.tbl_view_shared_data.isScrollEnabled = !is_pull_to_refresh
        
        self.home_view_model.getMyTrustedOrganizationApiCall(search: searchText,
                                                             currentPage: self.current_page,
                                                             view_for_progress_indicator: self.tbl_view_shared_data,
                                                             is_pull_to_refresh: is_pull_to_refresh)
        { is_success, model, search_active in
            
            self.shared_data_list = []
            
            if is_success, let list = model?.data?.organization_list , list.count > 0 {
                
                list.forEach { model in
                    if model.shared_data_count ?? 0 > 0 {
                        self.shared_data_list.append(SharedDataListModel(id: model.organizationId,
                                                                         organization_profile_image: model.organization_profile_image,
                                                                         organization_name: model.organization_name,
                                                                         shared_data_timestamp: model.shared_data_timestamp,
                                                                         mobile_number: model.shared_mobile_number,
                                                                         email_id: model.shared_email_address,
                                                                         address: model.shared_address,
                                                                         shared_social_data: model.shared_social_data,
                                                                         shared_data_count: model.shared_data_count))
                    }
                }
                
                self.total_pages = model?.data?.page_info?.total_pages ?? 1
                
                if self.current_page == 1 {
                    self.tbl_view_shared_data.shared_data_list = self.shared_data_list
                } else {
                    self.tbl_view_shared_data.shared_data_list.append(contentsOf: self.shared_data_list)
                }
                
                self.tbl_view_shared_data.hideNoDataLabel()
                
                DispatchQueue.main.async {
                    self.tbl_view_shared_data.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.tbl_view_shared_data.reloadData()
                    })
                }
                
            } else {
                
                if search_active {
                    self.tbl_view_shared_data.hideNoDataLabel()
                } else {
                    self.tbl_view_shared_data.showNoDataLabel(is_for_search: searchText != "")
                }
                
                self.tbl_view_shared_data.shared_data_list = []
                
                DispatchQueue.main.async {
                    self.tbl_view_shared_data.reloadData()
                }
            }
            
            self.tbl_view_shared_data.hideLoadingIndicatorInFooter()
            self.tbl_view_shared_data.hidePullToRefresh()
            self.tbl_view_shared_data.isScrollEnabled = true
            
        }
    }
}




