//
//  AppLockVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 07/11/23.
//

import UIKit

class AppLockVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_app_lock: AppLockTblView!
    
    var is_for_notification = false
    var saved_auto_lock_duration_in_seconds = 300
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: self.is_for_notification
                                                    ? LocalText.Notifications().notification()
                                                        :  LocalText.Settings().app_lock(),
                                               isWithBackOption: true)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.tblViewAppLockSetup()
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewAppLockSetup() {
        
        if let saved_app_lock_duration = UserDefaults.standard.value(forKey: UserDefaultsKey.app_lock_duration) as? Int {
            self.saved_auto_lock_duration_in_seconds = saved_app_lock_duration
        }
        
        if is_for_notification {
            let app_lock = AppLockBaseModel(model: [AppLockModel(
                header_title: LocalText.Notifications().notification(),
                options: [
                    AppLockModelDelay(is_selected: true, option: LocalText.AppLock().alerts()),
                    AppLockModelDelay(is_selected: false, option: LocalText.AppLock().updates()),
                    AppLockModelDelay(is_selected: false, option: LocalText.AppLock().data_insights()),
                ]),AppLockModel(
                    header_title: LocalText.AppLock().type_of_notification(),
                    options: [
                        AppLockModelDelay(is_selected: true, option: LocalText.AppLock().in_app()),
                        AppLockModelDelay(is_selected: false, option: LocalText.AppLock().push_notification()),
                        AppLockModelDelay(is_selected: false, option: LocalText.MyProfile().email()),
                        AppLockModelDelay(is_selected: false, option: LocalText.AppLock().sms())
                    ])
            ])
            
            self.tbl_view_app_lock.app_lock = app_lock
            
        } else {
            let app_lock = AppLockBaseModel(model: [AppLockModel(
                header_title: LocalText.AppLock().delay(),
                options: [
                    AppLockModelDelay(is_selected: self.saved_auto_lock_duration_in_seconds == 30, option: LocalText.AppLock().thirty_second()),
                    AppLockModelDelay(is_selected: self.saved_auto_lock_duration_in_seconds == 60, option: LocalText.AppLock().sixty_second()),
                    AppLockModelDelay(is_selected: self.saved_auto_lock_duration_in_seconds == 120, option: LocalText.AppLock().two_minute()),
                    AppLockModelDelay(is_selected: self.saved_auto_lock_duration_in_seconds == 300, option: LocalText.AppLock().five_minute())
                ])
            ])
            
            self.tbl_view_app_lock.app_lock = app_lock
        }
        
        self.tbl_view_app_lock.is_for_notification = self.is_for_notification
        self.tbl_view_app_lock.reloadData()
    }
}
