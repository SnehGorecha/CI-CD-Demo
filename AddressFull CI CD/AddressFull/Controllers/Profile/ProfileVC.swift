//
//  ProfileVC.swift
//  AddressFull
//
//  Created by Sneh on 11/27/23.
//

import UIKit


class ProfileVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_complete_your_profile: ProfileTblView!
    
    var is_from_login = false
    let my_profile_view_model = ProfileViewModel()
    var arr_data_to_delete = [ProfileDataModel]()
    var arr_sync_data_model = [SyncDataRequestModel]()
    var default_country_code = Country.getCurrentCountry()?.dialCode
    var country_code_selection_block : ((Country) -> Void)?
    
    var my_profile_model : PersonalDetailsModel = PersonalDetailsModel(
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
            country_code: UserDetailsModel.shared.country_code)],
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
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.tbl_view_complete_your_profile.setContentOffset(.zero, animated: false)
        }
    }
    
    override func refreshViaDataSyncNotification(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.setupUI()
            self.setupNavigationBar()
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = is_from_login ? .white : AppColor.primary_gray()
        self.tblViewMyProfileDetailsSetup()
        
        if self.is_from_login {
            self.fetchContactDetails()
        } else {
            self.retrivePersonalUserDetails()
        }
    }
    
    func setupNavigationBar() {
        self.navigation_bar.navigationBarSetup(title: !self.is_from_login
                                               ? LocalText.MyProfile().my_profile()
                                               : LocalText.Profile().complete_your_profile(),
                                               isWithBackOption: (self.is_from_login)
                                               ? nil
                                               : true,
                                               isWithRightOption: false,
                                               isWithQROption: !self.is_from_login,{
            
            self.compareProfileModels(new_profile_model: self.tbl_view_complete_your_profile.my_profile_model) {
                
                if self.arr_sync_data_model.count > 0 {
                    
                    self.arr_sync_data_model = []
                    
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
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewMyProfileDetailsSetup() {
        
        self.tbl_view_complete_your_profile.is_from_login = self.is_from_login
        self.tbl_view_complete_your_profile.is_edit_mode = self.is_from_login
        self.tbl_view_complete_your_profile.my_profile_model = self.my_profile_model
        
        self.tbl_view_complete_your_profile.addPullRefresh()
        
        self.tbl_view_complete_your_profile.pull_to_refresh_block = {
            self.setupUI()
        }
        
        // SAVE DATA
        self.tbl_view_complete_your_profile.did_save_pressed_block = { profile_model in
            
            self.resetMyProfileForLogin()
            
            self.compareProfileModels(new_profile_model: profile_model) {
                self.callProfileSyncAPI(profile_model: profile_model)
            }
        }
        
        // DELETE THE PROFILE DATA
        self.tbl_view_complete_your_profile.did_delete_pressed_block = { model,indexPath in
            let message = "\(Message.are_you_sure_you_want_to_delete_the()) \(model.type_of_field) \(indexPath.row + 1) ?"
            
            
            self.showPopupAlert(title: message,
                                message: nil,
                                leftTitle: LocalText.AlertButton().yes(),
                                rightTitle: LocalText.AlertButton().no(),
                                didPressedLeftButton: {
                self.deleteData(model: model, indexPath: indexPath)
            },
                                didPressedRightButton: nil)
        }
        
        // COUNTRY CODE
        self.tbl_view_complete_your_profile.did_country_code_btn_pressed_block = { index in
            self.openCountyCodePicker(index: index)
        }
        
        self.tbl_view_complete_your_profile.my_profile_model = self.my_profile_model
        
        DispatchQueue.main.async {
            self.tbl_view_complete_your_profile.reloadData()
        }
        
    }
    
    func openCountyCodePicker(index: Int) {
        self.country_code_selection_block = { country in
            self.tbl_view_complete_your_profile.my_profile_model.arr_mobile_numbers[index].country_code = country.code
            DispatchQueue.main.async {
                self.tbl_view_complete_your_profile.reloadSections(IndexSet(integer: 3), with: .automatic)
            }
        }
        
        let controller = DialCountriesController(locale: Locale(identifier: Locale.current.identifier))
        controller.delegate = self
        
        DispatchQueue.main.async {
            controller.show(vc: self)
        }
    }
    
    
    func deleteData(model: ProfileDataModel,indexPath: IndexPath) {
        self.view.showProgressBar()
        
        if model.field_id != "" {
            self.arr_data_to_delete.append(model)
        }
        
        if model.type_of_field == LocalText.PersonalDetails().mobile_number() {
            
            var new_mobile_models =  self.tbl_view_complete_your_profile.my_profile_model.arr_mobile_numbers
            new_mobile_models.remove(at: indexPath.row)
            self.tbl_view_complete_your_profile.my_profile_model.arr_mobile_numbers = new_mobile_models
            
        } else if model.type_of_field == LocalText.PersonalDetails().email() {
            
            var new_email_models =  self.tbl_view_complete_your_profile.my_profile_model.arr_email
            new_email_models.remove(at: indexPath.row)
            self.tbl_view_complete_your_profile.my_profile_model.arr_email = new_email_models
            
        } else if model.type_of_field == LocalText.PersonalDetails().address() {
            
            var new_address_models =  self.tbl_view_complete_your_profile.my_profile_model.arr_address
            new_address_models.remove(at: indexPath.row)
            self.tbl_view_complete_your_profile.my_profile_model.arr_address = new_address_models
        }
        
        
        if self.tbl_view_complete_your_profile.validation_failure_indexpath == indexPath {
            
            self.tbl_view_complete_your_profile.validation_failure_indexpath = nil
            
        } else if indexPath.row < self.tbl_view_complete_your_profile.validation_failure_indexpath?.row ?? 0 {
            
            self.tbl_view_complete_your_profile.validation_failure_indexpath = IndexPath(row: (self.tbl_view_complete_your_profile.validation_failure_indexpath?.row ?? 1) - 1, section: self.tbl_view_complete_your_profile.validation_failure_indexpath?.section ?? 0)
        }
        
        DispatchQueue.main.async {
            self.tbl_view_complete_your_profile.reloadSections(IndexSet(integer: indexPath.section), with: .left)
            self.view.hideProgressBar()
            self.dismiss(animated: true)
        }
        
    }
    
    // MARK: - API call
    
    func callProfileSyncAPI(profile_model: PersonalDetailsModel) {
        if self.arr_sync_data_model.count > 0 {
            
            self.my_profile_view_model.syncData(sync_data_model: SyncDataRequestBaseModel(shared_data: self.arr_sync_data_model), view_for_progress_indicator: self.view) { is_success, model in
                
                if is_success {
                    
                    if model?.isCronService ?? false {
                        do {
                            // SAVE NEW PROFILE DATA AND DELETE DATA IN TO USER DEFAULT
                            let new_profile_data = try JSONEncoder().encode(profile_model)
                            
                            UserDefaults.standard.set(new_profile_data, forKey: UserDefaultsKey.new_updated_profile_data)
                            
                            if self.arr_data_to_delete.count > 0 {
                                let deleted_data = try JSONEncoder().encode(self.arr_data_to_delete)
                                
                                UserDefaults.standard.set(deleted_data, forKey: UserDefaultsKey.new_deleted_profile_data)
                            }
                            
                            GlobalVariables.shared.sync_data_completed = false
                            
                            UserDefaults.standard.setValue(GlobalVariables.shared.sync_data_completed, forKey: UserDefaultsKey.sync_data_completed)
                            
                            self.arr_sync_data_model = []
                            
                        } catch(let err) {
                            UtilityManager().showToast(message: err.localizedDescription)
                        }
                        
                    } else {
                        self.setNewSharedProfileValues(profile_model: profile_model)
                    }
                    
                    
                    // SAVE PERSONAL DETAILS
                    let is_user_data_updated = ProfileViewModel().updateLoggedUserDetails(
                        image: profile_model.image
                    )
                    
                    print("Is logged details user data updated - \(is_user_data_updated)")
                    
                    self.showSuccessPopup(model: model)
                    
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.tbl_view_complete_your_profile.is_edit_mode = true
                        self.tbl_view_complete_your_profile.reloadData()
                    }
                }
            }
            
        } else {
            
            // SAVE PERSONAL DETAILS
            let is_user_data_updated = ProfileViewModel().updateLoggedUserDetails(
                image: profile_model.image
            )
            
            print("Is logged details user data updated - \(is_user_data_updated)")
            
            // SAVE SHARED DETAILS
            let isDataAdded = ProfileViewModel().saveLoggedUserPersonalDetails(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", profile_model: profile_model)
            
            print("Is Personal details user data added - \(isDataAdded)")
            
            UtilityManager().showToast(message: Message.profile_updated_successfully())
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
            self.retrivePersonalUserDetails()
        }
    }
    
    
    func showSuccessPopup(model: SignupResponseModel?) {
        let vc = self.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.setup(
            image: UIImage(named: AssetsImage.big_checkmark_checked) ?? UIImage(),
            title: model?.message ?? "",
            submitButtonTitle: LocalText.Settings().okay(),
            with_close_button: false)
        
        vc.did_submit_button_pressed_block = { () in
            
            DispatchQueue.main.async {
                
                vc.dismiss(animated: true) {
                    
                    // NAVIGATE TO TABBAR
                    if self.is_from_login {
                        let tabBarController = UIStoryboard().main().instantiateViewController(identifier: "TabBarController") as! TabBarController
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(tabBarController, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    self.tbl_view_complete_your_profile.is_edit_mode = !self.tbl_view_complete_your_profile.is_edit_mode
                    self.retrivePersonalUserDetails()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    
    /// This function will call if there is no my trusted organizations
    func setNewSharedProfileValues(profile_model: PersonalDetailsModel) {
        
        // CHECK IF ANY DATA NEED TO DELETE
        if self.arr_data_to_delete.count > 0 {
            self.arr_data_to_delete.forEach { model in
                let isDataAdded = ProfileViewModel().deleteLoggedUserPersonalDetails(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", model: model)
                print("Is Personal details user data deleted - \(isDataAdded)")
            }
        }
        
        
        // SAVE SHARED DETAILS
        let isDataAdded = ProfileViewModel().saveLoggedUserPersonalDetails(userID: "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)", profile_model: profile_model)
        
        print("Is Personal details user data added - \(isDataAdded)")
        
        // RETRIVE DATA
        self.retrivePersonalUserDetails()
    }
    
    
    // MARK: - ADD DATA IN arr_sync_data_model FOR API
    
    func compareProfileModels(new_profile_model : PersonalDetailsModel,_ completion:(() -> Void)) {
        
        self.arr_sync_data_model = []
        
        self.addFirstNameAndLastName(old_model: self.my_profile_model.first_name, new_model: new_profile_model.first_name, type: ApiHeaderAndParameters.firstName) {
            
            self.addFirstNameAndLastName(old_model: self.my_profile_model.last_name, new_model: new_profile_model.last_name, type: ApiHeaderAndParameters.lastName) {
                
                self.addDataForApiModel(old_values: self.my_profile_model.arr_mobile_numbers, new_values: new_profile_model.arr_mobile_numbers, type: ApiHeaderAndParameters.mobileNumber) {
                    
                    self.addDataForApiModel(old_values: self.my_profile_model.arr_email, new_values: new_profile_model.arr_email, type: ApiHeaderAndParameters.email) {
                        
                        self.addDataForApiModel(old_values: self.my_profile_model.arr_address, new_values: new_profile_model.arr_address, type: ApiHeaderAndParameters.address) {
                            
                            self.addSocialDataForApiModel(old_values: self.my_profile_model.arr_social_links, new_values: new_profile_model.arr_social_links) {
                                
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// This function is used to add first name and last name in arr_sync_data_model
    func addFirstNameAndLastName(old_model: ProfileDataModel,
                                 new_model: ProfileDataModel,
                                 type: String,
                                 _ completion:(() -> Void)) {
        
        var new_value = ""
        var old_value = ""
        
        // CHECK IF VALUE CHANGED OR NOT
        if new_model.value != old_model.value {
            new_value = "\(new_model.value)"
            old_value = "\(old_model.value)"
        }
        
        // REMOVE FROM PREVIOUS ARRAY IF VALUE NOT CHANGED
        else {
            self.removeDataFromArrAutoSync(type: "\(type)", value: "\(new_value)")
        }
        
        
        // ADD NEW VALUE IF IT IS NOT REMAIN EMPTY AFTER CHECKING ALL CONDITION
        if new_value != "" {
            let new_sync_model = SyncDataRequestModel(type: "\(type)",
                                                      value: new_value,
                                                      old_value: old_value)
            self.arr_sync_data_model.append(new_sync_model)
        }
        
        completion()
    }
    
    /// This function is used to add Mobile numbers, Emails and Address in arr_sync_data_model
    func addDataForApiModel(old_values: [ProfileDataModel],
                            new_values: [ProfileDataModel],
                            type: String,
                            _ completion:(() -> Void)) {
        
        for new_value_index in new_values.indices {
            
            var new_sync_value : String?
            var old_value : String?
            
            // THIS CONDITION IS FOR OLD DATA
            if new_value_index < old_values.count {
                
                // CHECK IF VALUE CHANGED OR NOT
                if new_values[new_value_index].value != old_values[new_value_index].value || new_values[new_value_index].country_code != old_values[new_value_index].country_code
                    
                {
                    // ADD COUNTRY CODE IF TYPE IS MOBILE NUMBER
                    if type == ApiHeaderAndParameters.mobileNumber {
                        
                        
                        let new_updated_value = "\(new_values[new_value_index].country_code?.dialCode().removePlusFromBegin() ?? "")|\(new_values[new_value_index].value)"
                        
                        new_sync_value = new_updated_value
                        
                        // PASS OLD VALUE ONLY IF NOT FROM LOGIN
                        old_value = self.is_from_login ? "" : "\(old_values[new_value_index].country_code?.dialCode().removePlusFromBegin() ?? "")|\(old_values[new_value_index].value)"
                        
                        
                    } else {
                        
                        let new_updated_value = "\(new_values[new_value_index].value)"
                        new_sync_value = new_updated_value
                        old_value = "\(old_values[new_value_index].value)"
                        
                    }
                }
                
                // REMOVE FROM PREVIOUS ARRAY IF VALUE NOT CHANGED
                else {
                    if type == ApiHeaderAndParameters.mobileNumber {
                        
                        self.removeDataFromArrAutoSync(type: "\(type)\(new_value_index + 1)", value: "\(new_values[new_value_index].country_code?.dialCode().removePlusFromBegin() ?? "")|\(new_values[new_value_index].value)")
                    } else {
                        self.removeDataFromArrAutoSync(type: "\(type)\(new_value_index + 1)", value: "\(new_values[new_value_index].value)")
                    }
                }
                
            }
            
            // THIS CONDITION IS FOR NEW ADDED DATA
            else {
                if type == ApiHeaderAndParameters.mobileNumber {
                    
                    new_sync_value = "\(new_values[new_value_index].country_code?.dialCode().removePlusFromBegin() ?? "")|\(new_values[new_value_index].value)"
                } else {
                    new_sync_value = "\(new_values[new_value_index].value)"
                }
                
                old_value = ""
            }
            
            
            // ADD NEW VALUE IF IT IS NOT REMAIN EMPTY AFTER CHECKING ALL CONDITION
            if new_sync_value != nil {
                let new_sync_model = SyncDataRequestModel(type: "\(type)\(new_value_index + 1)",
                                                          value: new_sync_value,
                                                          old_value: old_value)
                self.arr_sync_data_model.append(new_sync_model)
            }
        }
        
        if self.is_from_login {
            for new_index_for_login in new_values.count..<MaximumProfileData().count {
                let new_empty_sync_model = SyncDataRequestModel(type: "\(type)\(new_index_for_login + 1)",
                                                                value: "",
                                                                old_value: "")
                self.arr_sync_data_model.append(new_empty_sync_model)
            }
        }
        
        
        // ADD DELETED VALUES
        let remaining_value_count = old_values.count - new_values.count
        
        if remaining_value_count > 0 {
            
            // ADD EMPTY DATA
            for index in new_values.count..<old_values.count {
                
                if type == ApiHeaderAndParameters.mobileNumber {
                    
                    let new_sync_model = SyncDataRequestModel(type: "\(type)\(index + 1)",
                                                              value: "",
                                                              old_value: "\(old_values[index].country_code?.dialCode().removePlusFromBegin() ?? "")|\(old_values[index].value)")
                    self.arr_sync_data_model.append(new_sync_model)
                    
                } else {
                    
                    let new_sync_model = SyncDataRequestModel(type: "\(type)\(index + 1)",
                                                              value: "",
                                                              old_value: old_values[index].value)
                    self.arr_sync_data_model.append(new_sync_model)
                    
                }
            }
        }
        
        completion()
    }
    
    
    /// This function is used to add social links in arr_sync_data_model
    func addSocialDataForApiModel(old_values: [ProfileDataModel], new_values: [ProfileDataModel], _ completion:(() -> Void)) {
        
        for index in new_values.indices {
            var new_social_link_value = ""
            var old_social_link_value = ""
            
            // CHECK IF VALUE CHANGED OR NOT
            if new_values[index].value != old_values[index].value {
                
                new_social_link_value = new_values[index].value
                old_social_link_value = old_values[index].value
                
                let new_sync_model = SyncDataRequestModel(type: (index == 0)
                                                          ? ApiHeaderAndParameters.linkedin
                                                          : ApiHeaderAndParameters.twitter,
                                                          value: new_social_link_value,
                                                          old_value: old_social_link_value)
                self.arr_sync_data_model.append(new_sync_model)
            }
            
            // REMOVE FROM PREVIOUS ARRAY IF VALUE NOT CHANGED
            else {
                
                if new_values[index].type_of_value == LocalText.PersonalDetails().linkedin() {
                    
                    self.removeDataFromArrAutoSync(type: ApiHeaderAndParameters.linkedin, value: "\(new_values[index].value)")
                    
                } else if new_values[index].type_of_value == LocalText.PersonalDetails().twitter() {
                    
                    self.removeDataFromArrAutoSync(type: ApiHeaderAndParameters.twitter, value: "\(new_values[index].value)")
                }
                
            }
            
            if self.is_from_login && new_social_link_value == "" {
                let new_empty_sync_model = SyncDataRequestModel(type: (index == 0)
                                                                ? ApiHeaderAndParameters.linkedin
                                                                : ApiHeaderAndParameters.twitter,
                                                                value: "",
                                                                old_value: "")
                self.arr_sync_data_model.append(new_empty_sync_model)
            }
        }
        
        completion()
    }
    
    
    /// This function is used to delete data from arr_sync_data_model if already added
    func removeDataFromArrAutoSync(type: String,
                                   value: String) {
        
        let models = self.arr_sync_data_model.filter { model in
            model.type == type && model.old_value == value
        }.indices
        
        if models.count > 0 , let model_index = models.first {
            self.arr_sync_data_model.remove(at: model_index)
        }
    }
    
    
    func retrivePersonalUserDetails() {
        if let data = self.my_profile_view_model.retrieveLoggedUserPersonalDetails(country_code: UserDetailsModel.shared.country_code, mobile_number: UserDetailsModel.shared.mobile_number) {
            self.my_profile_model = data
        } else {
            self.my_profile_model = PersonalDetailsModel(
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
                    country_code: self.default_country_code)],
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
        }
        
        self.tbl_view_complete_your_profile.my_profile_model = self.my_profile_model
        
        DispatchQueue.main.async {
            self.tbl_view_complete_your_profile.reloadData()
            self.tbl_view_complete_your_profile.hidePullToRefresh()
        }
    }
    
    func resetMyProfileForLogin() {
        if self.is_from_login {
            self.my_profile_model = PersonalDetailsModel(
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
                    value: "",
                    country_code: self.default_country_code)],
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
        }
    }
}


// MARK: - EXTENSION COUNTRY CODE
extension ProfileVC : DialCountriesControllerDelegate {
    
    func didSelected(with country: Country) {
        if let country_code_selection_block = self.country_code_selection_block {
            country_code_selection_block(country)
        }
    }
}
