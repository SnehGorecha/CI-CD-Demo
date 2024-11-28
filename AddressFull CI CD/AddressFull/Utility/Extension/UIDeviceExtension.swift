//
//  UIDeviceExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 17/11/23.
//

import Foundation
import UIKit

extension UIDevice {
    func getDeviceID() -> String? {
        let identifier = UIDevice.current.identifierForVendor?.uuidString
        return identifier
    }
}
