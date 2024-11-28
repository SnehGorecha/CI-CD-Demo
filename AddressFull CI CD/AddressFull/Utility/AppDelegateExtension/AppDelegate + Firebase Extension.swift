//
//  AppDelegate + Firebase Extension.swift
//  FirebaseBaseProject
//
//  Created by Sneh on 10/18/23.
//

import Foundation
import FirebaseMessaging
import FirebaseCore
import FirebaseInAppMessaging
import UserNotifications


// MARK: - SetUp
extension AppDelegate  {
    
    /// Use this function to set up firebase with functionalities like configuration , notification, analytics, crashlytics.
    func setupFirebase(application: UIApplication) {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        InAppMessaging.inAppMessaging().delegate = self
        requestNotificationAuthorization(application: application)
        Messaging.messaging().delegate = self
    }
}



// MARK: - Push Notification
extension AppDelegate : UNUserNotificationCenterDelegate , MessagingDelegate {
    
    
    /// Use this function to request permssions for notification
    func requestNotificationAuthorization(application:UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        )
    }
    
    
    // MARK: - Register notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error in didRegisterForRemoteNotificationsWithDeviceToken : \(error.localizedDescription)")
            } else if let token = token {
                print("\nFCM TOKEN from didRegisterForRemoteNotifications : \(token)\n")
                GlobalVariables.shared.fcm_token = token
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error in didFailToRegisterForRemoteNotificationsWithError : ",error.localizedDescription)
    }
    
    
    // MARK: - Handle notifications taps and action button taps
    
    /// This function is called when notification is received when app is in background or terminated.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("\ndidReceiveRemoteNotification : \(userInfo)\n")
        
        if (UserDefaults.standard.value(forKey: UserDefaultsKey.mobile_number) as? String) != nil {
            
            self.checkNotification(user_info: userInfo)
            
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    
    /// This function is called when notification is received when app is in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("\nuserNotificationCenter - willPresent : \(notification.request.content.userInfo)\n")
        
        if (UserDefaults.standard.value(forKey: UserDefaultsKey.mobile_number) as? String) != nil {
            
            self.checkNotification(user_info: notification.request.content.userInfo)
            
            if #available(iOS 14.0, *) {
                completionHandler([.sound,.list,.badge,.banner])
            } else {
                UIApplication.topViewController()?.showPopupAlert(title: AppInfo.app_name,
                                                                  message: Message.upgrade_your_os_version(),
                                                                  leftTitle: nil,
                                                                  rightTitle: LocalText.AlertButton().ok(),
                                                                  close_button_hidden: true,
                                                                  didPressedLeftButton: nil,
                                                                  didPressedRightButton: nil)
            }
        }
    }
    
    
    /// This function is called when tap on notification in any app state.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("\nuserNotificationCenter - didReceive : \(response.notification.request.content.userInfo)\n")
        
        if (UserDefaults.standard.value(forKey: UserDefaultsKey.mobile_number) as? String) != nil {
            
            self.navigateToControllerFromNotification(user_info: response.notification.request.content.userInfo)
            
            completionHandler()
        }
    }
    
    
    // MARK: - Custom functions
    func navigateToControllerFromNotification(user_info: [AnyHashable : Any]) {
        if UIApplication.topViewController() is DeleteConfirmationSuccessVC {
            DispatchQueue.main.async {
                UIApplication.topViewController()?.dismiss(animated: true) {
                    self.openControllerAfterDeleteAlert(user_info: user_info)
                }
            }
        }
        else {
            self.openControllerAfterDeleteAlert(user_info: user_info)
        }
    }
    
    func openControllerAfterDeleteAlert(user_info: [AnyHashable : Any]) {
        if let extra_data = user_info["extraData"] as? String  {
            if let dictionary = extra_data.toDictionary() {
                if let type = dictionary["type"] as? Int {
                    
                    // PROFILE NOTIFICATION
                    if type == PushNotificationType.auto_sync.rawValue {
                        if let top_vc = UIApplication.topViewController() {
                            top_vc.navigateTo(.profile_vc(is_from_login: false))
                        } else {
                            let profile_vc = UIViewController().getController(from: .profile, controller: .profile_vc(is_from_login: false)) as! ProfileVC
                            LockManager.shared.vc_from_notification = profile_vc
                        }
                    }
                    
                    // REQUEST NOTIFICATION
                    else if type == PushNotificationType.request.rawValue {
                        
                        if let top_vc = UIApplication.topViewController(), !(top_vc is RequestVC) {
                            top_vc.navigateTo(.request_vc)
                        } else {
                            let request_vc = UIViewController().getController(from: .home, controller: .request_vc) as! RequestVC
                            LockManager.shared.vc_from_notification = request_vc
                        }
                    }
                    
                    // DELETE ORGANIZATION NOTIFICATION
                    else if type == PushNotificationType.delete_organization.rawValue {
                        
                        if let tab_bar_controller = UIApplication.findTabBarController() {
                            tab_bar_controller.selectedIndex = 0
                        } else {
                            let home_vc = UIViewController().getController(from: .main, controller: .home_vc) as! HomeVC
                            LockManager.shared.vc_from_notification = home_vc
                        }
                    }
                }
            }
        }
    }
    
    func checkNotification(user_info: [AnyHashable : Any]) {
        if let extra_data = user_info["extraData"] as? String  {
            
            if let dictionary = extra_data.toDictionary() {
                
                if let type = dictionary["type"] as? Int {
                    
                    if let status = dictionary["status"] as? Bool {
                        
                        if type == PushNotificationType.auto_sync.rawValue || type == PushNotificationType.delete_organization.rawValue {
                            
                            let message = dictionary["message"] as? String
                            self.setUserInteraction(status: status,type: type,message: message)
                        }
                    }
                    
                    if type == PushNotificationType.request.rawValue {
                        
                        NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
    
    func setUserInteraction(status: Bool,type: Int,message: String?) {
        
        GlobalVariables.shared.sync_data_completed = true
        
        UserDefaults.standard.set(status, forKey: UserDefaultsKey.auto_sync_api_status)
        UserDefaults.standard.set(GlobalVariables.shared.sync_data_completed, forKey: UserDefaultsKey.sync_data_completed)
        
        NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_all_views), object: nil, userInfo: [NotificationName.data_synchronized : status])
        
        if type == PushNotificationType.delete_organization.rawValue {
            
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_top_trusted_vc), object: nil, userInfo: nil)
            
        }
        
        ProfileViewModel().setProfileData(status: status)
        
        self.showAlert(status: status, type: type,message: message)
    }
    
    func showAlert(status: Bool,type: Int,message: String?) {
        if type == PushNotificationType.auto_sync.rawValue && UIApplication.shared.applicationState == .active {
            if let top_vc = UIApplication.topViewController() {
                let vc = top_vc.getController(from: .settings, controller: .delete_confirmation_vc) as! DeleteConfirmationSuccessVC
                vc.modalPresentationStyle = .overFullScreen
                
                vc.setup(
                    image: UIImage(named: AssetsImage.big_checkmark_checked) ?? UIImage(),
                    title: message ?? "",
                    submitButtonTitle: LocalText.Settings().okay(),
                    with_close_button: false)
                
                vc.did_submit_button_pressed_block = { () in
                    DispatchQueue.main.async {
                        vc.dismiss(animated: true) {
                            GlobalVariables.shared.popup_showed = false
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if !GlobalVariables.shared.popup_showed {
                        top_vc.present(vc, animated: true)
                        GlobalVariables.shared.popup_showed = true
                    }
                }
            }
        }
    }
}



// MARK: - Generate token
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let fcmToken = fcmToken {
        
        GlobalVariables.shared.fcm_token = fcmToken
        print("\nFCM TOKEN : \(fcmToken)\n")
    }
}


// MARK: - In-App-Messsage
extension AppDelegate : InAppMessagingDisplayDelegate {
    func messageClicked(_ inAppMessage: InAppMessagingDisplayMessage, with action: InAppMessagingAction) {
        
        print("In-app message clicked: \(inAppMessage)")
        // TODO: Example for navigate
        /*  if ((action.actionURL?.absoluteString.contains("SecondController")) != nil) {
         if let rootViewController = self.window?.rootViewController {
         let secondController = rootViewController.storyboard?.instantiateViewController(identifier: "SecondViewController") as? SecondViewController
         rootViewController.present(secondController!, animated: false)
         }
         } */
    }
    
    func impressionDetected(for inAppMessage: InAppMessagingDisplayMessage) {
        
        print("In-app message displayed: \(inAppMessage)")
    }
}
