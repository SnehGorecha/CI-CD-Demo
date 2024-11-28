//
//  LockManager.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import Foundation
import UIKit


class LockManager {
    
    static let shared = LockManager()
    
    var vc_from_notification : UIViewController?
    
    /// Use this function to ask for authentication
    func askForAuthentication(top_vc: UIViewController) {
        
        // Check Face ID,Touch ID or Passcode is enabled or not
        if BiometricLockManager.shared.checkBiometricType().0 == .face || BiometricLockManager.shared.checkBiometricType().0 == .touch || BiometricLockManager.shared.checkBiometricType().0 == .passcode {
            if !GlobalVariables.shared.asked_for_password {
                self.authenticate(using: BiometricLockManager.shared.checkBiometricType().0,top_vc: top_vc)
            }
        } else {
            self.navigateToController(top_vc: top_vc)
        }
        
//        // Check Security Quesions
//        else if let two_step_verification_question_answers = AddTwoStepVerificationViewModel().retrieveTwoStepVerificationQuestionAnswer(userID: UserDetailsModel.shared.mobile_number), two_step_verification_question_answers.count > 0 {
//            
//            self.userHasTwoStepVerification(two_step_verification_question_answers: two_step_verification_question_answers,top_vc: top_vc)
//        } 
        
//        else {
//            
//            DispatchQueue.main.async {
//                let tabBarController = UIStoryboard().main().instantiateViewController(identifier: "TabBarController") as! TabBarController
//                top_vc.navigationController?.pushViewController(tabBarController, animated: true)
//            }
//        }
    }
    
    
    // MARK: - Face ID, Touch ID or Passcode
    
    /// Use this function to ask for bioemtric authentication
    func authenticate(using lock_type: BiometricType,top_vc: UIViewController) {
        
        GlobalVariables.shared.asked_for_password = true
        
        BiometricLockManager.shared.authenticate(withReason: LocalText.BioMetricAuthentication().identify_yourself(), lockType: (lock_type == .face || lock_type == .touch) ? .TouchORFaceID : .passcode) 
        { (is_success, error_message) in
            
            if is_success {
                self.navigateToController(top_vc: top_vc)
            } else {
                top_vc.showPopupAlert(title: AppInfo.app_name,
                                    message: Message.for_your_security_you_can_only_use_when_its_unlock(),
                                    leftTitle: nil,
                                    rightTitle: LocalText.BioMetricAuthentication().unlock(),
                                    close_button_hidden: true,
                                    didPressedLeftButton: nil,
                                    didPressedRightButton: {
                    
                    top_vc.dismiss(animated: true)
                    self.authenticate(using: lock_type, top_vc: top_vc)
                })
                
            }
        }
    }
    
    
    func navigateToController(top_vc: UIViewController) {
        if top_vc is SplashVC || top_vc is SignUpOTPVC {
            
            if let vc_from_notification = self.vc_from_notification {
                GlobalVariables.shared.vc_from_notification = vc_from_notification
            }
            
            // IF APP WAS TERMINATED AND OPENED AGAIN
            DispatchQueue.main.async {
                let tabBarController = UIStoryboard().main().instantiateViewController(identifier: "TabBarController") as! TabBarController
                top_vc.navigationController?.pushViewController(tabBarController, animated: true)
            }
        } else {
            
            // IF APP WAS IN FOREGROUND OR IN BACKGROUND AND OPENED AGAIN
            DispatchQueue.main.async {
                if self.vc_from_notification is RequestVC && !(top_vc is RequestVC) {
                    top_vc.navigateTo(.request_vc)
                } else if self.vc_from_notification is ProfileVC  && !(top_vc is ProfileVC) {
                    top_vc.navigateTo(.profile_vc(is_from_login: false))
                }
            }
            self.vc_from_notification = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            GlobalVariables.shared.is_app_launched = true
            GlobalVariables.shared.asked_for_password = false
        })
    }
    
    // MARK: - Two step verification questions
    
    /// Use this function to ask for two fector authentication
    func userHasTwoStepVerification(two_step_verification_question_answers: [TwoStepVerificationQuestionAnswerModel],top_vc: UIViewController?) {
        
        top_vc?.navigateTo(.login_with_security_question_vc(
            is_from_splash_screen: top_vc is SplashVC || top_vc is SignUpOTPVC,
            two_step_verification_question_answer_list: two_step_verification_question_answers))
        
    }
    
}
