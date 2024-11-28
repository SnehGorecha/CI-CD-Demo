//
//  SplashVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import UIKit

class SplashVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var is_onboarding_finished = false
    var ask_for_authentication = false
    
    @IBOutlet weak var lbl_desc: AFLabelRegular!
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.checkKeysAndDeviceId()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = AppColor.primary_green()
        self.lbl_desc.text = LocalText.SplashScreen().consent_based_information_sharing_application()
        self.lbl_desc.textColor = .white
        self.is_onboarding_finished = UserDefaults.standard.value(forKey: UserDefaultsKey.is_onboarding_finished) as? Bool ?? false
    }
    
    func checkKeysAndDeviceId() {
        UtilityManager().checkDeviceId()
        
//        KeyExchange.deleteKeysFromKeychain()
        KeyExchange.completion = { is_success,error_message in
            if is_success {
                self.checkLocalDataCreated()
            } else {
                self.showPopupAlert(title: AppInfo.app_name,
                                    message: error_message,
                                    leftTitle: nil,
                                    rightTitle: LocalText.AlertButton().ok(),
                                    close_button_hidden: true,
                                    didPressedLeftButton: nil,
                                    didPressedRightButton: nil)
            }
        }
        
        KeyExchange.retriveKeysFromKeyChain(view_for_progress_indicator: self.view)
        
    }
    
    func checkLocalDataCreated() {
        
        if CoreDataManager().isCoreDataStoreCreated(databaseName: AppInfo.app_name) {
            
            
            let value = UserDefaults.standard.value(forKey: UserDefaultsKey.sync_data_completed) as? Bool
            GlobalVariables.shared.sync_data_completed = value ?? true
            
            if let mobile_number = UserDefaults.standard.value(forKey: UserDefaultsKey.mobile_number) as? String,
               let country_code = UserDefaults.standard.value(forKey: UserDefaultsKey.country_code) as? String {

                ProfileViewModel().retrieveLoggedUserPersonalDetails(country_code: country_code,
                                                                     mobile_number: mobile_number)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (self.ask_for_authentication ? 0 : 3), execute: {
                
                // Check If app is temporary locked or not
                if (UserDefaults.standard.value(forKey: UserDefaultsKey.time_after_two_mins) != nil) {
                    
                    self.navigateTo(.temporary_lock_vc)
                    
                } else {
                    
                    // Check if User has logged in or not
                    if UserDetailsModel.shared.token != "" {
                        
                        self.checkForSessionTimeout {
                            
                            // Check if User has completed profile or not
                            if UserDetailsModel.shared.first_name == "" && UserDetailsModel.shared.last_name == "" && GlobalVariables.shared.sync_data_completed {
                                
                                self.navigateTo(.profile_vc(is_from_login: true))
                                
                            } else {
                                
                                // ASK FOR AUTHENTICATION
                                LockManager.shared.askForAuthentication(top_vc: self)
                            }
                            
                        }
                    }
                    else {
                        
                        // User has logged out
                        
                        let onboarding_vc = self.getController(from: .onboarding, controller: .onboarding_vc(scroll_to_at: 0)) as! OnboardingVC
                        if self.is_onboarding_finished {
                            onboarding_vc.scroll_to_at = onboarding_vc.arr_button_titles.count
                        }
                        self.navigationController?.pushViewController(onboarding_vc, animated: true)
                    }
                }
            })
        } else {
            print("\nCore Data store doesn't exist or couldn't be loaded.\n")
        }
    }

    
    func checkForSessionTimeout(completion: @escaping(() -> Void)) {
        if let lastOpenedDate = UserDefaults.standard.object(forKey: UserDefaultsKey.last_opened_date) as? Date {
            
            let day_difference = Calendar.current.dateComponents([.day], from: lastOpenedDate, to: Date()).day ?? 0
            
             
            if day_difference >= TokenValidity().jwt {
                BaseViewController().logoutUser(message: Message.your_session_has_been_expired())
            } 
            else if day_difference >= TokenValidity().local {
                self.callRefreshTokenApi {
                    completion()
                }
            }
            else {
                completion()
            }
            
        } else {
            completion()
        }
        
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKey.last_opened_date)
        
    }
    
    
    // MARK: - API CALL
    
    func callRefreshTokenApi(completion: @escaping(() -> Void)) {
        
        SplashViewModel().refreshTokenApiCall(view_for_progress_indicator: self.view) { is_success, model in
            
            if let token = model?.data?.token {
                UserDetailsModel.shared.token = token
                
                let is_user_data_updated = ProfileViewModel().updateLoggedUserDetails(
                    token: token
                )
                
                print("Is logged details user data updated - \(is_user_data_updated)")
            }
            
            completion()
        }
        
    }
}
