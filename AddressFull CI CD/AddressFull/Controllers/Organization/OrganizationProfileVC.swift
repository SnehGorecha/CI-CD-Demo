//
//  OrganizationProfileVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 03/11/23.
//

import UIKit

class OrganizationProfileVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var is_top_trusted_organization = false
    var organization_model : OrganizationListModel?
    let my_profile_view_model = ProfileViewModel()
    let organization_profile_view_model = OrganizationProfileViewModel()
    var id = ""
    var arr_share_data_model = [SyncDataRequestModel]()
    var old_profile_model : PersonalDetailsModel?
    var is_came_from_scanner = false
    
    @IBOutlet weak var view_progress_indicator: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_organization_profile_details: OrganizationProfileUserDetailsTblView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationBar()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view_progress_indicator.backgroundColor = AppColor.primary_gray()
        self.view_progress_indicator.showProgressBar()
        self.tblViewOrganizationProfileSetup()
        self.retrivePersonalUserDetails()
        self.getOrganizationProfile(id: self.id)
        NotificationCenter.default.addObserver(self, selector: #selector(popController), name: Notification.Name(NotificationName.reload_home_vc), object: nil)
    }
    
    func setupNavigationBar() {
        self.navigation_bar.navigationBarSetup(isWithBackOption: true,{
            
            self.compareAllValues(for_navigation_back:true) {
                
                if self.arr_share_data_model.count > 0 {
                    
                    self.showPopupAlert(title: Message.discard_changes(),
                                        message: Message.are_you_sure_you_want_to_go_back(),
                                        leftTitle: LocalText.AlertButton().yes(),
                                        rightTitle: LocalText.AlertButton().no(),
                                        didPressedLeftButton: {
                        self.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    },
                                        didPressedRightButton: nil)
                    
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    
    func setIsSelectedForSharedData() {
        
        self.tbl_view_organization_profile_details.my_profile_model.first_name.is_selected = true
        self.tbl_view_organization_profile_details.my_profile_model.last_name.is_selected = true
        
        self.organization_model?.shared_mobile_number?.forEach({ shared_value in
            let shared_index = shared_value - 1
            if shared_index < self.tbl_view_organization_profile_details.my_profile_model.arr_mobile_numbers.count {
                self.tbl_view_organization_profile_details.my_profile_model.arr_mobile_numbers[shared_index].is_selected = true
            }
        })
        
        self.organization_model?.shared_email_address?.forEach({ shared_value in
            let shared_index = shared_value - 1
            if shared_index < self.tbl_view_organization_profile_details.my_profile_model.arr_email.count {
                self.tbl_view_organization_profile_details.my_profile_model.arr_email[shared_index].is_selected = true
            }
        })
        
        self.organization_model?.shared_address?.forEach({ shared_value in
            let shared_index = shared_value - 1
            if shared_index < self.tbl_view_organization_profile_details.my_profile_model.arr_address.count {
                self.tbl_view_organization_profile_details.my_profile_model.arr_address[shared_index].is_selected = true
            }
        })
        
        if self.organization_model?.shared_social_data?.linkedin != "" && self.organization_model?.shared_social_data?.linkedin != nil {
            self.tbl_view_organization_profile_details.my_profile_model.arr_social_links[0].is_selected = true
        }
        
        if self.organization_model?.shared_social_data?.twitter != "" && self.organization_model?.shared_social_data?.twitter != nil {
            self.tbl_view_organization_profile_details.my_profile_model.arr_social_links[1].is_selected = true
        }
        
        self.old_profile_model = self.tbl_view_organization_profile_details.my_profile_model
        
        self.tbl_view_organization_profile_details.checkResetAndSelectAll()
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewOrganizationProfileSetup() {
        
        self.tbl_view_organization_profile_details.is_top_trusted_organization = self.is_top_trusted_organization
        self.tbl_view_organization_profile_details.organization_model = self.organization_model
        self.tbl_view_organization_profile_details.checkResetAndSelectAll()
        self.tbl_view_organization_profile_details.is_my_trusted = self.organization_model?.is_trusted ?? false
        
        self.tbl_view_organization_profile_details.did_tap_share_my_profile_block = {
            self.shareDataToOrganization()
        }
        
        self.tbl_view_organization_profile_details.did_tap_more_button_block = {
            self.navigateTo(.organization_more_option_vc(organization_model: self.organization_model,
                                                         is_from_notification: false,
                                                         button_titles: [
                                                            LocalText.OrganizationMoreOptions().view_shared_data(),
                                                            LocalText.OrganizationMoreOptions().delete_organization(),
                                                            LocalText.OrganizationMoreOptions().block_organization()],
                                                         block_completion: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }))
        }
        
        DispatchQueue.main.async {
            self.tbl_view_organization_profile_details.reloadData()
        }
    }
    
    func shareDataToOrganization() {
        
        if self.tbl_view_organization_profile_details.isReset() != nil {
            UtilityManager().showToast(message: self.tbl_view_organization_profile_details.isReset() ?? "")
        } else {
            
            self.compareAllValues(for_navigation_back: false) {
                if self.arr_share_data_model.count > 0 {
                    
                    let request_model = ShareDataRequestBaseModel(organization_id: self.id,shared_data: self.arr_share_data_model)
                    self.shareDataApiCall(request_model: request_model)
                    
                } else {
                    
                    // TODO: Change label
                    UtilityManager().showToast(message: LocalText.OrganizationProfile().please_update_any_value())
                }
            }
            
        }
    }
    
    func compareAllValues(for_navigation_back: Bool ,_ completion:(() -> Void)) {
        
        self.arr_share_data_model = []
        
        self.compareProfileDatas(old_profile_data: self.old_profile_model?.arr_mobile_numbers ?? [],
                                 new_profile_data: self.tbl_view_organization_profile_details.my_profile_model.arr_mobile_numbers,
                                 type_of_value: ApiHeaderAndParameters.mobileNumber)
        {
            self.compareProfileDatas(old_profile_data: self.old_profile_model?.arr_email ?? [],
                                     new_profile_data: self.tbl_view_organization_profile_details.my_profile_model.arr_email,
                                     type_of_value: ApiHeaderAndParameters.email)
            {
                self.compareProfileDatas(old_profile_data: self.old_profile_model?.arr_address ?? [],
                                         new_profile_data: self.tbl_view_organization_profile_details.my_profile_model.arr_address,
                                         type_of_value: ApiHeaderAndParameters.address)
                {
                    self.compareProfileDatas(old_profile_data: self.old_profile_model?.arr_social_links ?? [],
                                             new_profile_data: self.tbl_view_organization_profile_details.my_profile_model.arr_social_links,
                                             type_of_value: ApiHeaderAndParameters.social_links)
                    {
                        if self.organization_model?.shared_mobile_number?.count ?? 0 > 0 || for_navigation_back {
                            completion()
                            
                        } else {
                            self.addFirstNameAndLastName(new_profile_data: self.tbl_view_organization_profile_details.my_profile_model) {
                                
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func compareProfileDatas(old_profile_data : [ProfileDataModel],
                             new_profile_data : [ProfileDataModel],
                             type_of_value: String,
                             _ completion:(() -> Void)) {
        
        for index in 0..<old_profile_data.count {
            
            let old_model = old_profile_data[index]
            let new_model = new_profile_data[index]
            
            if old_model.is_selected != new_model.is_selected {
                
                var old_value_to_share = ""
                var new_value_to_share = ""
                var type = ""
                
                type = new_model.type_of_value
                
                // Add country code if mobile number
                if type_of_value == ApiHeaderAndParameters.mobileNumber {
                    
                    type = "\(type_of_value)\(index + 1)"
                    new_value_to_share = new_model.is_selected ? "\(new_model.country_code?.dialCode().removePlusFromBegin() ?? "")|\(new_model.value)" : ""
                    old_value_to_share = new_model.is_selected ? "" : "\(old_model.country_code?.dialCode().removePlusFromBegin() ?? "")|\(old_model.value)"
                    
                }
                // Manage type for social links
                else if type_of_value == ApiHeaderAndParameters.social_links {
                    
                    type = new_model.type_of_value == LocalText.PersonalDetails().linkedin() ? ApiHeaderAndParameters.linkedin : ApiHeaderAndParameters.twitter
                    new_value_to_share = new_model.is_selected ? "\(new_model.value)" : ""
                    old_value_to_share = new_model.is_selected ? "" : "\(old_model.value)"
                    
                }
                // For other values
                else {
                    
                    type = "\(type_of_value)\(index + 1)"
                    new_value_to_share = new_model.is_selected ? "\(new_model.value)" : ""
                    old_value_to_share = new_model.is_selected ? "" : "\(old_model.value)"
                }
                
                let new_sync_model = SyncDataRequestModel(type: type,
                                                          value: new_value_to_share,
                                                          old_value: old_value_to_share)
                self.arr_share_data_model.append(new_sync_model)
            }
        }
        
        completion()
    }
    
    
    /// This function is used to add first name and last name only first time
    func addFirstNameAndLastName(new_profile_data: PersonalDetailsModel,_ completion:(() -> Void)) {
        
        let first_name_model = SyncDataRequestModel(type: ApiHeaderAndParameters.firstName,
                                                    value: new_profile_data.first_name.value,
                                                    old_value: "")
        let last_name_model = SyncDataRequestModel(type: ApiHeaderAndParameters.lastName,
                                                   value: new_profile_data.last_name.value,
                                                   old_value: "")
        
        self.arr_share_data_model.append(contentsOf: [first_name_model,last_name_model])
        
        completion()
    }
    
    
    func retrivePersonalUserDetails() {
        if let data = self.my_profile_view_model.retrieveLoggedUserPersonalDetails(country_code: UserDetailsModel.shared.country_code, mobile_number: UserDetailsModel.shared.mobile_number) {
            self.tbl_view_organization_profile_details.my_profile_model = data
        } else {
            self.tbl_view_organization_profile_details.my_profile_model = PersonalDetailsModel(
                first_name: ProfileDataModel(type_of_field: LocalText.Profile().first_name(),
                                             type_of_value: LocalText.Profile().first_name(),
                                             value: ""),
                last_name: ProfileDataModel(type_of_field: LocalText.Profile().last_name(),
                                            type_of_value: LocalText.Profile().last_name(),
                                            value: ""),image: Data(),
                arr_mobile_numbers: [
                    ProfileDataModel(type_of_field: LocalText.PersonalDetails().mobile_number(),
                                     type_of_value: LocalText.PersonalDetails().primary(),
                                     value: "",
                                     country_code: UserDetailsModel.shared.country_code)
                ],
                arr_email: [
                    ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(),
                                     type_of_value: LocalText.PersonalDetails().primary(),
                                     value: "")
                ],
                arr_address: [
                    ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(),
                                     type_of_value: LocalText.PersonalDetails().home(),
                                     value: "")
                ],
                arr_social_links: [
                    ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                     type_of_value: LocalText.PersonalDetails().linkedin(),
                                     value: ""),
                    ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                     type_of_value: LocalText.PersonalDetails().twitter(),
                                     value: "")
                ]
            )
        }
        
        DispatchQueue.main.async {
            self.tbl_view_organization_profile_details.reloadData()
        }
    }
    
    func hideLoader() {
        self.tblViewOrganizationProfileSetup()
        self.setIsSelectedForSharedData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.view_progress_indicator.isHidden = true
        })
    }
    
    // MARK: - OBJC FUNCTIONS
    
    @objc func popController() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - API CALL
    
    func getOrganizationProfile(id: String) {
        
        self.organization_profile_view_model.getOrganizationProfileApiCall(id: id,
                                                                           view_for_progress_indicator: nil)
        { is_success, model in
            
            // If Success
            if is_success, let data = model?.data {
                self.organization_model = data
                
                // If Came from Scanner
                if self.is_came_from_scanner {
                    
                    // Show alert if any data has been shared with this organization or not
                    self.showPopupAlert(
                        title: data.shared_mobile_number?.count ?? 0 > 0 ?          "\(Message.you_have_already_shared_your_data_with()) \(data.organization_name ?? ""). \(Message.would_you_like_to_update())" : "\(Message.you_are_about_to_share_your_data_with()) \(data.organization_name ?? ""). \(Message.would_you_like_to_go_ahead())",
                        message: nil,
                        leftTitle: LocalText.AlertButton().yes(),
                        rightTitle: LocalText.AlertButton().no(),
                        close_button_hidden: true)
                    {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                        
                        self.hideLoader()
                        
                    } didPressedRightButton: {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
                
                // Not came from Scanner
                else {
                    self.hideLoader()
                }
                
            } 
            
            // Go back if any error occured
            else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func shareDataApiCall(request_model: ShareDataRequestBaseModel) {
        
        self.organization_profile_view_model.shareDataToOrganizationApiCall(
            share_data_request_model : request_model,
            view_for_progress_indicator: self.view)
        { is_success, model in
            
            if is_success {
                DispatchQueue.main.async {
                    
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil, userInfo: nil)
                    
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil, userInfo: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
