//
//  AutoLock.swift
//  AddressFull
//
//  Created by Sneh on 12/17/23.
//

import Foundation
import UIKit


class AutoLock {
    
    static let shared = AutoLock()
    
    var inactivity_timer: Timer?
    var inactivity_duration: TimeInterval = 300.0
    
    func startInactivityTimer() {
        
        // TODO: Comment this for auto app lock
        
        if let saved_app_lock_duration = UserDefaults.standard.value(forKey: UserDefaultsKey.app_lock_duration) as? Int {
            self.inactivity_duration = TimeInterval(saved_app_lock_duration)
        }
        
        self.inactivity_timer?.invalidate()
        self.inactivity_timer = Timer.scheduledTimer(timeInterval: inactivity_duration, target: self, selector: #selector(handleInactivity), userInfo: nil, repeats: false)
    }
    
    
    @objc func handleInactivity() {
        (UIApplication.shared.delegate as? AppDelegate)?.askForAuthentication()
    }
}


// MARK: - TOUCH EVENT FOR WINDOW
class CustomWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == .began {
                    AutoLock.shared.startInactivityTimer()
                    break
                }
            }
        }
    }
}


// MARK: - TOUCH EVENT FOR TEXTVIEW
class TouchInterceptingTextView: UITextView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AutoLock.shared.startInactivityTimer()
    }
}


// MARK: - TOUCH EVENT FOR TEXTFIELD
class TouchInterceptingTextField: UITextField {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        AutoLock.shared.startInactivityTimer()
    }
}
