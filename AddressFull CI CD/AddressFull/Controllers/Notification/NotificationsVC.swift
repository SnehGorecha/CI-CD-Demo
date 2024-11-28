//
//  NotificationsVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class NotificationsVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_notification_list: NotificationTblView!
    @IBOutlet weak var segment_notification_type: BaseSegmentControl!
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Notifications().notification(),
                                               isWithBackOption: true,
                                               isWithRightOption: false)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.localTextSetup()
        self.tblViewNotificationSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViaNotification), name: Notification.Name(NotificationName.reload_notification_vc), object: nil)
    }
    
    func localTextSetup() {
        self.segment_notification_type.setTitle(LocalText.Request().recent(), forSegmentAt: 0)
        self.segment_notification_type.setTitle(LocalText.Request().previous(), forSegmentAt: 1)
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewNotificationSetup() {

        self.tbl_view_notification_list.is_for_notification = true
        
        DispatchQueue.main.async {
            self.tbl_view_notification_list.reloadData()
        }
        
        self.tbl_view_notification_list.didBtnMorePressedBlock = { (row, section) in
            self.navigateTo(.organization_more_option_vc(organization_model: nil,
                                                         is_from_notification: true,
                                                         button_titles: [
                                                            LocalText.Notifications().remove_notification(),
                                                            LocalText.Notifications().block_notification(),
                                                            LocalText.ReportReason().report()],
                                                        block_completion: nil))
        }
    }
    
    // MARK: OBJC METHODS
    
    @objc func refreshViaNotification() {
        
    }
    
    // MARK: SEGMENT ACTIONS
    
    @IBAction func segment_notification_type_changed(_ sender: BaseSegmentControl) {
        
    }
}


