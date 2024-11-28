//
//  UITextFieldExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import Foundation
import UIKit


extension UITextField {
    func setPlaceholder(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func set(strFont: String) {
        
        let font = UIFont(name: strFont, size: self.font?.pointSize ?? 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        self.font = font
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.font: font])
    }
}
