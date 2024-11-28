//
//  BiometricLockManager.swift
//  BaseProject
//
//  Created by MacBook Pro  on 12/10/23.
//

import Foundation
import LocalAuthentication


enum LockType {
    case passcode
    case TouchORFaceID
}

enum BiometricType {
    case none
    case passcode
    case touch
    case face
}


class BiometricLockManager {
    
    static let shared = BiometricLockManager()
    

    func checkBiometricType() -> (BiometricType, String) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .faceID:
                return (.face, "")
            case .touchID:
                return (.touch, "")
            case .none:
                return (.none, BiometricErrorMesages.biometryNotEnrolled)
            @unknown default:
                return (.none, BiometricErrorMesages.biometryNotEnrolled)
            }
        } else {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                return (.passcode, "")
            } else {
                return (.none, BiometricErrorMesages.biometryNotEnrolled)
            }
        }
    }
    
    func isPasscodeSet() -> Bool {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: AppInfo.app_name,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
        ]

        let status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
        return status != errSecItemNotFound
    }


    
    func authenticate(withReason: String, lockType : LockType = .passcode, completionHandler: @escaping (_ isSuccss: Bool, _ errorMessage: String?) -> Void) {
        
        let context = LAContext()
        var error: NSError?
        let policy: LAPolicy = .deviceOwnerAuthentication 
        
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: withReason) { (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        completionHandler(true, nil)
                    } else {
                        if let code = error?.code {
                            completionHandler(false, self.evaluateAuthenticationPolicyMessageForLA(errorCode: code))
                        }
                        else {
                            completionHandler(false, authenticationError?.localizedDescription)
                        }
                    }
                }
            }
        } else {
            if let code = error?.code {
                completionHandler(false, self.evaluateAuthenticationPolicyMessageForLA(errorCode: code))
            }
            else {
                completionHandler(false, error?.localizedDescription)
            }
        }
    }
    
    fileprivate func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = BiometricErrorMesages.biometryNotAvailable
                
            case LAError.biometryLockout.rawValue:
                message = BiometricErrorMesages.biometryLockout
                
            case LAError.biometryNotEnrolled.rawValue:
                message = BiometricErrorMesages.biometryNotEnrolled
                
            default:
                message = BiometricErrorMesages.defaultMessage
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = BiometricErrorMesages.touchIdLockout
                
            case LAError.touchIDNotAvailable.rawValue:
                message = BiometricErrorMesages.touchIdNotAvailable
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = BiometricErrorMesages.touchIdNotEnrolled
                
            default:
                message = BiometricErrorMesages.defaultMessage
            }
        }
        
        return message;
    }
    
    fileprivate func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = BiometricErrorMesages.authenticationFailed
            
        case LAError.appCancel.rawValue:
            message = BiometricErrorMesages.appCancel
            
        case LAError.invalidContext.rawValue:
            message = BiometricErrorMesages.invalidContext
            
        case LAError.notInteractive.rawValue:
            message = BiometricErrorMesages.notInteractive
            
        case LAError.passcodeNotSet.rawValue:
            message = BiometricErrorMesages.passcodeNotSet
            
        case LAError.systemCancel.rawValue:
            message = BiometricErrorMesages.systemCancel
            
        case LAError.userCancel.rawValue:
            message = BiometricErrorMesages.userCancel
            
        case LAError.userFallback.rawValue:
            message = BiometricErrorMesages.userFallback
            
        default:
            message = self.evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
