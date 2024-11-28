//
//  UIButtonExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


extension UIButton {
    
    /// This function will make multi line text into UIButton
    func makeMultiline() {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    
    /// This function will be used to setup text with title color and background color, title color and background by defalt as mentioned in function's parameter
    func setup(titleColor: UIColor =  .black, backgroundColor: UIColor = .white, title: String) {
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
    
    func removeText() {
        self.setTitle("", for: .normal)
    }

    func setStyle(withGrayBackground: Bool = false,
                  withClearBackground : Bool = false,
                  cornerRadius: CGFloat = 14,
                  bg_color : UIColor? = nil,
                  title_color : UIColor? = nil,
                  border_color : UIColor? = nil) {
        
        self.backgroundColor = bg_color != nil ? bg_color : withGrayBackground ? AppColor.primary_gray() : withClearBackground ? .clear : AppColor.primary_green()
        self.setTitleColor(title_color != nil ? title_color : withGrayBackground ? .black : withClearBackground ? AppColor.primary_green() : .white, for: .normal)
        self.setupLayer(borderColor: (border_color != nil) ? (border_color ?? .black) : withClearBackground ? AppColor.primary_green() : .clear, borderWidth: 1.0, cornerRadius: cornerRadius)
    }
    
    func setStyleWithout(border: Bool, backgroundColor: UIColor) {
        
        if border {
            self.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 0.0)
        }
        self.backgroundColor = backgroundColor
    }
    
    func setUndeline(withText: String, fontColor: UIColor) {
        
        if let fontSize = self.titleLabel?.font.pointSize {
            
            let yourAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: AppFont.helvetica_regular, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: fontColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributeString = NSMutableAttributedString(
                string: withText,
                attributes: yourAttributes
            )
            self.setAttributedTitle(attributeString, for: .normal)
        }
    }
    
}
