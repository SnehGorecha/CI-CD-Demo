//
//  BaseViewController.swift
//  Authentication
//
//  Created by MacBook Pro  on 15/09/23.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {
    
    
    // MARK: VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.primary_gray()
        self.backScreenGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViaDataSyncNotification(_:)), name: Notification.Name(NotificationName.reload_all_views), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlertFromNotification(_:)), name: Notification.Name(NotificationName.login_popup), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let value = UserDefaults.standard.value(forKey: UserDefaultsKey.sync_data_completed) as? Bool
        GlobalVariables.shared.sync_data_completed = value ?? true
        
        DispatchQueue.main.async {   
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func refreshViaDataSyncNotification(_ notification: NSNotification) {
        
    }
    
    // MARK: CUSTOM FUNCTIONS
    
    func setup(separatorView: [UIView]) {
        separatorView.forEach { view in
            view.backgroundColor = .clear
        }
    }
    
    
    /// This function will be used to enable/disable back gesture to go to previous screen
    func backScreenGesture(isEnabled: Bool = false) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
    
    /// This function will be used to hide navgation bar
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /// This function will be used to show navgation bar
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /// This function will be used to temporary lock the app
    func temporaryLockTheApp() {
        self.navigateTo(.temporary_lock_vc)
    }
    
    
    /// This function will be used to logout the user
    func logoutUser(message: String? = nil) {
        
        let deleted = SignUpOTPViewModel().deleteTokenAfterLogout()
        print("Is token deleted from Logged user details - \(deleted)")
        
        if let message = message, message == Message.your_session_has_been_expired() || message == Message.logout_successfully() {
            UtilityManager().showToast(message: message)
        }
        
        self.setRootControllerAfterTokenDeleted(message:message)
    }
    
    
    /// This function will be used to delete user account and delete all the details from coredata
    func deleteUserAccount(message: String? = nil) {
        let is_user_details_deleted = CoreDataManager.delete(mulitple_values: true,
                                                             withPrediction: [
                                                                CoreDataBase.Entity.LoggedUserDetails.Fields.mobile_number : UserDetailsModel.shared.mobile_number,
                                                                CoreDataBase.Entity.LoggedUserDetails.Fields.country_code : UserDetailsModel.shared.country_code
                                                             ],
            forEntityName: CoreDataBase.Entity.LoggedUserDetails.entity_name)
        print("Is user details deleted from database for user - \(UserDetailsModel.shared.mobile_number) - \(is_user_details_deleted)")
        
        let is_user_personal_details_deleted = CoreDataManager.delete(mulitple_values: true,
            withPrediction: [CoreDataBase.Entity.LoggedUserPersonalDetails.Fields.user_id : "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)"],
            forEntityName: CoreDataBase.Entity.LoggedUserPersonalDetails.entity_name)
        print("Is user personal details deleted from database for user - \(UserDetailsModel.shared.mobile_number) - \(is_user_personal_details_deleted)")
        
        let is_two_step_questions_deleted = CoreDataManager.delete(mulitple_values: true,
            withPrediction: [CoreDataBase.Entity.TwoStepVerificationQuestion.Fields.user_id : "\(UserDetailsModel.shared.country_code) \(UserDetailsModel.shared.mobile_number)"],
            forEntityName: CoreDataBase.Entity.TwoStepVerificationQuestion.entity_name)
        print("Is two step questions deleted from database for user - \(UserDetailsModel.shared.mobile_number) - \(is_two_step_questions_deleted)")
        
        self.setRootControllerAfterTokenDeleted(message: message)
    }
    
    
    /// This function will be used to set root controller and retrive updated data after token deleted
    fileprivate func setRootControllerAfterTokenDeleted(message: String? = nil) {
        
        DispatchQueue.main.async {
     
            if let message = message , message != Message.your_session_has_been_expired() , message != Message.logout_successfully() {
                NotificationCenter.default.post(name: Notification.Name(NotificationName.login_popup), object: nil, userInfo: [NotificationUserInfo.message : message])
            }
            
            UserDetailsModel.shared = UserDetailsModel()
            
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.mobile_number)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.country_code)
            
            let vc = self.getController(from: .onboarding, controller: .onboarding_vc(scroll_to_at: 0)) as! OnboardingVC
            
            vc.scroll_to_at = vc.arr_button_titles.count
            
            let navVC = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navVC
            
            GlobalVariables.shared.is_app_launched = false
            
        }
    }
    
    @objc func showAlertFromNotification(_ notification : Notification) {
        let user_info = notification.userInfo as? [String:Any]
        if let message = user_info?[NotificationUserInfo.message] as? String {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                let vc =  UIApplication.topViewController()?.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
                vc.modalPresentationStyle = .overFullScreen
                
                vc.setup(
                    image: UIImage(named: AssetsImage.big_checkmark_checked) ?? UIImage(),
                    title: message,
                    submitButtonTitle: LocalText.Settings().okay(),
                    with_close_button: false)
               
                
                vc.did_submit_button_pressed_block = { () in
                    vc.dismiss(animated: true)
                }
                
                if !(UIApplication.topViewController() is DeleteConfirmationSuccessVC) {
                    UIApplication.topViewController()?.present(vc, animated: true)
                }
//
//                UIApplication.topViewController()?.showPopupAlert(title: message,
//                                    message: nil,
//                                    leftTitle: nil,
//                                    rightTitle: LocalText.Settings().okay(),
//                                    close_button_hidden: true,
//                                    didPressedLeftButton: nil,
//                                    didPressedRightButton: nil)
            })
        }
    }
 
}
