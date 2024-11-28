//
//  TemporaryLockVC.swift
//  AddressFull
//
//  Created by Sneh on 12/2/23.
//

import UIKit

class TemporaryLockVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var time_difference = TimeInterval()
    var stored_time = Date()
    
    @IBOutlet weak var lbl_timer: AFLabelRegular!
    @IBOutlet weak var lbl_desc: AFLabelRegular!
    @IBOutlet weak var lbl_app_is_locked: AFLabelBold!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    
    // MARK: - COMMON FUNCTION
    
    func setup() {
        if (UserDefaults.standard.value(forKey: UserDefaultsKey.time_after_two_mins) == nil) {
            self.saveTimeInUserDefaults()
        }
        self.setupUI()
        self.calculateTimeDifferenceAndStartTimer()
        self.lbl_desc.text = "\(LocalText.TemporaryLock().app_is_temporary_locked())"
    }
    
    func setupUI() {
        self.view.backgroundColor = AppColor.primary_green()
        self.lbl_timer.textColor = .white
        self.lbl_desc.textColor = .white
        self.lbl_app_is_locked.textColor = .white
    }
    
    func calculateTimeDifferenceAndStartTimer() {
        if let stored_time = UserDefaults.standard.value(forKey: UserDefaultsKey.time_after_two_mins) as? Date {
            self.stored_time = stored_time
            self.time_difference = stored_time.timeIntervalSince(Date())
            
            if self.time_difference > 0 {
                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                timer.fire()
                Timer.scheduledTimer(withTimeInterval: self.time_difference, repeats: false) { new_timer in
                    timer.invalidate()
                    new_timer.invalidate()
                    
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.time_after_two_mins)
                    UserDefaults.standard.setValue(5, forKey: UserDefaultsKey.password_attempts)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.otp_resent_count)

                    self.navigateTo(.onboarding_vc(scroll_to_at: 0))
                }
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.time_after_two_mins)
                UserDefaults.standard.setValue(5, forKey: UserDefaultsKey.password_attempts)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.otp_resent_count)
            }
        }
    }
    
    func saveTimeInUserDefaults() {
        let currentTime = Date()
        let twoMinutesLater = Calendar.current.date(byAdding: .minute, value: 2, to: currentTime)
        UserDefaults.standard.set(twoMinutesLater, forKey: UserDefaultsKey.time_after_two_mins)
    }
 
    
    // MARK: - OBJC FUNCTION
    
    @objc func updateTimer() {
        self.time_difference = self.stored_time.timeIntervalSince(Date())
        let minutes = Int(time_difference) / 60
        let seconds = Int(time_difference) % 60
        let remaining_time =  String(format: "%02d:%02d", minutes, seconds)
        self.lbl_timer.text = "\(LocalText.TemporaryLock().you_can_login_again_after()) \(remaining_time)"
    }
    
}
