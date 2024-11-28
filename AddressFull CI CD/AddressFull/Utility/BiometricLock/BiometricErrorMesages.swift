//
//  BiometricErrorMesages.swift
//  BaseProject
//
//  Created by MacBook Pro  on 12/10/23.
//

import Foundation


struct BiometricErrorMesages {
    
    static let biometryNotAvailable = LocalText.BioMetricAuthentication().biometryNotAvailable()
    static let biometryLockout = LocalText.BioMetricAuthentication().biometryLockout()
    static let biometryNotEnrolled = LocalText.BioMetricAuthentication().biometryNotEnrolled()
    static let defaultMessage = LocalText.BioMetricAuthentication().defaultMessage()
    static let touchIdLockout = LocalText.BioMetricAuthentication().touchIDLockout()
    static let touchIdNotAvailable = LocalText.BioMetricAuthentication().touchIDNotAvailable()
    static let touchIdNotEnrolled = LocalText.BioMetricAuthentication().touchIDNotEnrolled()
    static let authenticationFailed = LocalText.BioMetricAuthentication().authenticationFailed()
    static let appCancel = LocalText.BioMetricAuthentication().appCancel()
    static let invalidContext = LocalText.BioMetricAuthentication().invalidContext()
    static let notInteractive = LocalText.BioMetricAuthentication().notInteractive()
    static let passcodeNotSet = LocalText.BioMetricAuthentication().passcodeNotSet()
    static let systemCancel = LocalText.BioMetricAuthentication().systemCancel()
    static let userCancel = LocalText.BioMetricAuthentication().userCancel()
    static let userFallback = LocalText.BioMetricAuthentication().userFallback()
}
