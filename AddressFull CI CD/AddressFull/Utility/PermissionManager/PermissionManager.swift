//
//  PermissionManager.swift
//  PermissionManager
//
//  Created by Sneh on 10/20/23.
//

import Foundation
import UIKit
import Photos
import AVFoundation
import LocalAuthentication
import ContactsUI


/// Use this clouser to check location status after permission pop up
var permissionManagerLocationCompletion : ((Bool) -> ())?

/// Use this clouser to check coordinates of current location
var permissionManagerLocationCoordinateCompletion : ((_ coordinates : CLLocationCoordinate2D) -> ())?


/// Enum of permission type
enum Permission : String , CaseIterable {
    case camera = "Camera"
    case photoLibrary = "Photo library"
    case pushNotification = "Push notification"
    case faceId = "Face ID"
    case contact = "Contact"
    case location = "Location"
}


/// Generic class for managing permissions
class PermissionManager {
    
    // MARK: - Properties
    /// Shared intance of permission manager class
    static let shared = PermissionManager()
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate let faceIdContext = LAContext()
    fileprivate let contactStore = CNContactStore()

    /// Alert title when permission denied
    var defaultAlertTitle = ""
        
    /// Alert positive button title when permission denied
    var defaultPostitiveButtonTitle = LocalText.AlertButton().settings()
    
    /// Alert negetive button title when permission denied
    var defaultNagetiveButtonTitle = LocalText.AlertButton().cancel()
    
    
    // MARK: - Public Functions
    /// Use this function to check authorization status of any permissions. (NOTE: Use permissionManagerBluetoothCompletion, permissionManagerLocationCompletion, permissionManagerLocalNetworkCompletion for checking status for bluetooth, location and local network.)
    ///
    /// Not allowed clouser is optional. if you want to set your custom action you can use it. Otherwise by default it will present alert from showAlert(permission: Permission,parentController : UIViewController).
    
    @available(iOS 14, *)
    func checkPermission(for permissions : [Permission],parentController : UIViewController,Allowed:@escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        permissions.forEach { permission in
            switch permission {
            case .camera:
                self.checkPermissionForCamera(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            case .photoLibrary:
                self.checkPermissionForPhotolibrary(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            case .pushNotification:
                self.checkPermissionForPushNotification(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            case .faceId:
                self.checkPermissionForFaceId(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            case .contact:
                self.checkPermissionForContacts(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            case .location:
                self.checkPermissionForLocation(parentController: parentController, Allowed: Allowed,NotAllowed: NotAllowed)
            }
        }
    }
    
    /// Use this function to check authorization status of camera
    fileprivate func checkPermissionForCamera(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video)  { isGranted in
                    isGranted
                    ? self.completion(permission: .camera, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                    : self.completion(permission: .camera, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                }
            case .restricted,.denied:
                self.completion(permission: .camera, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            case .authorized:
                self.completion(permission: .camera, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            @unknown default:
                break
            }
        }
    }
    
    
    /// Use this function to check authorization status of photo library
    @available(iOS 14, *)
    fileprivate func checkPermissionForPhotolibrary(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { isGranted in
                        (isGranted == .authorized)
                        ? self.completion(permission: .photoLibrary, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                        : self.completion(permission: .photoLibrary, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                    }
                }
            case .restricted,.denied,.limited:
                self.completion(permission: .photoLibrary, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            case .authorized:
                self.completion(permission: .photoLibrary, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            @unknown default:
                break
            }
        }
    }
    
    
    /// Use this function to check authorization status of push notification
    fileprivate func checkPermissionForPushNotification(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    self.completion(permission: .pushNotification, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                case .denied, .ephemeral, .provisional:
                    self.completion(permission: .pushNotification, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { isGranted,error in
                        isGranted
                        ? self.completion(permission: .pushNotification, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                        : self.completion(permission: .pushNotification, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                    }
                @unknown default:
                    break
                }
            }
        }
    }
    
    /// Use this function to check authorization status of faceId or password
    fileprivate func checkPermissionForFaceId(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if self.faceIdContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
                self.faceIdContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { isGranted,error in
                    isGranted
                    ? self.completion(permission: .faceId, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                    : self.completion(permission: .faceId, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                }
            } else {
                self.completion(permission: .faceId, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            }
        }
    }

    /// Use this function to check authorization status of contacts
    fileprivate func checkPermissionForContacts(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.completion(permission: .contact, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
        case .denied, .restricted:
            self.completion(permission: .contact, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
        case .notDetermined:
            contactStore.requestAccess(for: .contacts, completionHandler: { isGranted,error in
                isGranted
                ? self.completion(permission: .contact, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
                : self.completion(permission: .contact, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
            })
        @unknown default:
            break
        }
    }
    
    /// Use this function to check authorization status of location
    @available(iOS 14.0, *)
    fileprivate func checkPermissionForLocation(parentController : UIViewController,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil) {
        self.locationManager.delegate = parentController
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.completion(permission: .location, allowed: true, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
        case .denied,.restricted:
            self.completion(permission: .location, allowed: false, Allowed: Allowed, NotAllowed: NotAllowed, parentController)
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    /// Use this function to show alert for denied permissions
    func showAlert(permission: Permission,parentController : UIViewController) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "\(AppInfo.app_name) \(Message.does_not_have_access_to_your()) \(permission.rawValue). \(Message.to_enable_acces_tap_settings_and_turn_on()) \(permission.rawValue)", message: nil, preferredStyle: .alert)
            
            let openSettingsAction = UIAlertAction(title: self.defaultPostitiveButtonTitle, style: .default) { action in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: self.defaultNagetiveButtonTitle, style: .cancel, handler: nil)
            
            alert.addAction(openSettingsAction)
            alert.addAction(cancelAction)
            
            parentController.present(alert, animated: true)
        }
    }
    
    
    /// Comlpletion function for permission denied
    fileprivate func completion(permission: Permission,allowed:Bool,Allowed: @escaping() -> Void, NotAllowed: (() -> Void)? = nil,_ parentController: UIViewController) {
        if allowed {
            Allowed()
        } else {
            if let notAllowed = NotAllowed {
                notAllowed()
            } else {
                self.showAlert(permission: permission, parentController: parentController)
            }
        }
        
    }

}


// MARK: - Controller Extension
extension UIViewController : CLLocationManagerDelegate {
    
    
    /// Override method for location update status in permission manager class
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            if let locationPermissionClouser = permissionManagerLocationCompletion {
                locationPermissionClouser(true)
            }
            
            DispatchQueue.global(qos: .background).async {   
                if CLLocationManager.locationServicesEnabled() {
                    manager.startUpdatingLocation()
                }
            }
        case .denied,.restricted:
            if let locationPermissionClouser = permissionManagerLocationCompletion {
                locationPermissionClouser(false)
            }
        default:
            break
        }
    }
    
    
    /// Override method for location to get updateed location in permission manager class
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if let locationCoordinateClouser = permissionManagerLocationCoordinateCompletion {
            locationCoordinateClouser(location)
        }
    }
}

