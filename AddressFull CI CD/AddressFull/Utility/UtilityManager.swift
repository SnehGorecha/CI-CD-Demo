//
//  UtilityManager.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SnapKit
import SwiftEntryKit


class UtilityManager {
    
    
    /// This function is used to show alert view or action sheet as per type setup which is mentioned in this function's parameter
    func alert(vc: UIViewController = UIApplication.topViewController() ?? UIViewController(), title: String, msg: String, buttons: [String], alertStyle: UIAlertController.Style = .alert, withTextField: Bool = false, completionHandler: ((_ index: Int, _ title: String, _ textFieldText: String?) -> Void)?) {
                
        vc.popupAlert(title: title, message: msg, alertStyle: alertStyle, withTextField: withTextField, actionTitles: buttons, completionHandler: completionHandler)
    }
    
    
    /// This function will be used to open device's external browser with particular link to opne
    func openExternalBrowser(urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    /// This function will be used to calculate propotional height based on baseHeight
    func getPropotionalHeight(baseHeight: CGFloat,height: CGFloat) -> CGFloat {
        return ((UIScreen.main.bounds.height * (( height * 100 ) / baseHeight )) / 100)
    }
    
    @MainActor private func showCustomToast(message : String,topvc: BaseViewController) {
        IQKeyboardManager.shared.resignFirstResponder()
        let labelView = UIView()
        let toastLabel = UILabel()
        labelView.backgroundColor = AppColor.primary_gray()
        toastLabel.textColor = UIColor.black
        toastLabel.font = UIFont(name: AppFont.helvetica_bold, size: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        labelView.layer.cornerRadius = 20
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        labelView.clipsToBounds = true
        labelView.isHidden = true
        
        DispatchQueue.main.async {
            toastLabel.snp.removeConstraints()
            labelView.snp.removeConstraints()
            toastLabel.removeFromSuperview()
            labelView.removeFromSuperview()
        }
        
        if labelView.superview == nil && toastLabel.superview == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                labelView.addSubview(toastLabel)
                topvc.view.addSubview(labelView)
                
                labelView.isHidden = false
                
                toastLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(labelView).offset(-15)
                    make.leading.equalTo(labelView).offset(15)
                    make.trailing.equalTo(labelView).offset(-15)
                    make.top.equalTo(labelView).offset(15)
                }
                
                labelView.snp.makeConstraints { make in
                    make.top.equalTo(topvc.view).offset(40)
                    make.leading.greaterThanOrEqualTo(UIApplication.shared.windows.last ?? topvc.view).offset(24)
                    make.trailing.lessThanOrEqualTo(UIApplication.shared.windows.last ?? topvc.view).offset(-24)
                    make.centerX.equalTo(UIApplication.shared.windows.last ?? topvc.view)
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                    labelView.frame.origin.y += topvc.view.frame.origin.y + 50
                    
                } completion: { (isCompleted) in
                    UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseOut) {
                        
                        labelView.frame.origin.y -= topvc.view.frame.midY
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            labelView.isHidden = true
                            labelView.removeFromSuperview()
                            toastLabel.removeFromSuperview()
                        }
                    }
                }
            })
        }
    }
    
    
    
    /// This function will be used to show toast message
    func showToast(message : String) {
        let title = EKProperty.LabelContent(
            text: "",
            style: .init(
                font: UIFont(name: AppFont.helvetica_regular, size: 0) ?? .systemFont(ofSize: 0),
                color: .white),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: message,
            style: .init(
                font: UIFont(name: AppFont.helvetica_regular, size: 16) ?? .systemFont(ofSize: 16),
                color: .white,
                alignment: .center
            ),
            accessibilityIdentifier: "description"
        )
        
        let simpleMessage = EKSimpleMessage(
            title: title,
            description: description
        )
        
        var attributes: EKAttributes
        attributes = .topFloat
        attributes.displayMode = .light
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .color(color: EKColor(AppColor.toast_bg_color()))
        attributes.roundCorners = .all(radius: 20)
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: AppFont.helvetica_regular, size: 16) ?? .systemFont(ofSize: 16)]
           let text = message
        let width = (text as NSString).size(withAttributes: fontAttributes).width
        _ = (text as NSString).size(withAttributes: fontAttributes).height
        
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: width * 1.5),
            height: .intrinsic
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        if message != "" {
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
        
    }
    
    /// This function will be used to check device id and save it to keychain
    func checkDeviceId() {
        if let saved_device_id = KeyChain().load(key: KeyChainKey.device_id, group: KeyChainKey.group) {
            let string_device_id = String(data: saved_device_id, encoding: .utf8) ?? ""
            GlobalVariables.shared.device_id = string_device_id
            print("\nSaved Device ID - \(string_device_id)\n")
        } else {
            let new_device_id = UIDevice().getDeviceID() ?? ""
            GlobalVariables.shared.device_id = new_device_id
            let is_device_id_saved = KeyChain().save(data: GlobalVariables.shared.device_id.data(using: .utf8) ?? Data(), key: KeyChainKey.device_id, group: KeyChainKey.group)
            print("\nNew generated Device ID - \(GlobalVariables.shared.device_id)")
            print("\nNew generated Device ID \(is_device_id_saved ? "saved" : "not saved")\n")
        }
    }
}
