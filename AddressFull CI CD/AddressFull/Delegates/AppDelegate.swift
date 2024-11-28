//
//  AppDelegate.swift
//  AddressFull
//
//  Created by MacBook Pro  on 30/10/23.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    // MARK: - OBJECTS
    
    var window: UIWindow?
    
    
    // MARK: - LIFE CYCLE
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupIQKeyboard()
        self.setRootControllerAndWindow()
        self.askForAuthentication()
        self.setupFirebase(application: application)
        self.checkForAutoSyncData()
        self.checkForAppVersionUpdate()
        
        
        let ipStackApiKey = "8837b5e004afe49c2381e458a9f2352c"
        self.fetchIPLocationUsingIPStack(apiKey: ipStackApiKey) { result, error in
            if let result = result {
                print("IPStack Response:", result)
            } else if let error = error {
                print("Error:", error.localizedDescription)
            }
        }

        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if GlobalVariables.shared.is_app_launched {
            AutoLock.shared.startInactivityTimer()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.askForAuthentication()
    }
    
    
    // MARK: Deep linking
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
//            self.handleDeepLink(url)
            UtilityManager().showToast(message: "\(url)")
            DispatchQueue.main.async {
                UIApplication.topViewController()?.showPopupAlert(
                    title: "Deep linking",
                    message: "\(url)",
                    leftTitle: nil,
                    rightTitle: LocalText.VersionUpdate().update_now(),
                    image_icon: AssetsImage.report_big,
                    is_img_hidden: false,
                    is_for_version_update: true,
                    close_button_hidden: false,
                    didPressedLeftButton: {
                        UIApplication.topViewController()?.dismiss(animated: true)
                    },
                    didPressedRightButton: {
                        UIApplication.topViewController()?.dismiss(animated: true)
                    })
            }
            
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        UtilityManager().showToast(message: "\(url)")
        DispatchQueue.main.async {
            UIApplication.topViewController()?.showPopupAlert(
                title: "Function Open URL",
                message: "\(url)",
                leftTitle: nil,
                rightTitle: LocalText.VersionUpdate().update_now(),
                image_icon: AssetsImage.report_big,
                is_img_hidden: false,
                is_for_version_update: true,
                close_button_hidden: false,
                didPressedLeftButton: {
                    UIApplication.topViewController()?.dismiss(animated: true)
                },
                didPressedRightButton: {
                    UIApplication.topViewController()?.dismiss(animated: true)
                })
        }
        return true
    }
    
    func fetchIPLocationUsingIPStack(apiKey: String, completion: @escaping (NSDictionary?, Error?) -> Void) {
        let urlString = "https://api.ipstack.com/check?access_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    do {
                        if let object = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            completion(object, nil)
                        } else {
                            completion(nil, nil)
                        }
                    } catch let parsingError {
                        completion(nil, parsingError)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - CUSTOM FUNCTION
    
    func setupIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    func checkForAutoSyncData() {
        if let status = UserDefaults.standard.value(forKey: UserDefaultsKey.auto_sync_api_status) as? Bool {
            ProfileViewModel().setProfileData(status: status)
        }
    }
    
    func askForAuthentication() {
        DispatchQueue.main.async {
            if GlobalVariables.shared.is_app_launched
                && !GlobalVariables.shared.asked_for_password
                && (UserDefaults.standard.value(forKey: UserDefaultsKey.time_after_two_mins) == nil) && UserDetailsModel.shared.token != "" {
                if let top_vc = UIApplication.topViewController() {
                    LockManager.shared.askForAuthentication(top_vc: top_vc)
                }
            }
        }
    }
    
    func setRootControllerAndWindow() {
        self.window = CustomWindow(frame: UIScreen.main.bounds)
        
        let vc = UIViewController().getController(from: .splash, controller: .splash_vc) as! SplashVC
        let navVC = UINavigationController(rootViewController: vc)
        
        self.window?.rootViewController = navVC
    }
    
    func handleDeepLink(_ url: URL) {
        UtilityManager().showToast(message: "\(url)")
//        print("Universal link URL: \(url)")
    }
    
    func checkForAppVersionUpdate() {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                guard let data = data else { return }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                        return
                    }
                    
                    if let result = (json["results"] as? [Any])?.first as? [String: Any],
                       let latestVersion = result["version"] as? String,
                       let appid = result["trackId"] as? Int  {
                        
                        if Double(latestVersion) ?? 0.0 > Double(currentVersion) ?? 0.0 {
                            self.callForceUpdateAPI(appid: appid)
                        }
                        
                    }
                } catch(let err) {
                    print("Error in checkForUpdate : \(err.localizedDescription)")
                }
            }.resume()
        }
    }
    
    func callForceUpdateAPI(appid: Int) {
        AppDelegateViewModel().forceUpdateApiCall { is_success, model in
            self.showVersionUpdateAlert(appid: appid,forceUpdate: model?.forceUpdate ?? false)
        }
    }
    
    func showVersionUpdateAlert(appid: Int,forceUpdate: Bool) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.showPopupAlert(
                title: Message.new_version_available_title(),
                message: Message.new_version_available_message(),
                leftTitle: nil,
                rightTitle: LocalText.VersionUpdate().update_now(),
                image_icon: AssetsImage.report_big,
                is_img_hidden: false,
                is_for_version_update: true,
                close_button_hidden: forceUpdate,
                didPressedLeftButton: {
                    UIApplication.topViewController()?.dismiss(animated: true)
                },
                didPressedRightButton: {
                    UIApplication.topViewController()?.dismiss(animated: true)
                    if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appid)") {
                        UIApplication.shared.open(url)
                    }
                })
        }
    }
}

