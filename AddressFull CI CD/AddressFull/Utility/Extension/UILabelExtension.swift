//
//  UILabelExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


fileprivate var globalRangeText = ""
fileprivate var textOnTapBlock : (() -> Void)!
fileprivate var informationIconOnTapBlock : (() -> Void)!

extension UILabel {
    
    /// This function will be used to setup click event of a UIlabel for particular part of text
    func setupTapGesture(rangeText: String, onTap: @escaping (() -> Void)) {
        
        globalRangeText = rangeText
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        
        textOnTapBlock = { () in
            onTap()
        }
    }
    
    
    /// Beow mentioned function is connected with UILabel's tap gesture to detect text clict event
    @objc fileprivate  func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        
        guard let text = self.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: globalRangeText), recognizer.didTapAttributedTextInLabel(label: self, inRange: NSRange(range, in: text)) {
            if textOnTapBlock != nil {
                textOnTapBlock()
            }
        }
    }
    
    func setAttributedString(str: String, attributedStr: [String], font : String, size : CGFloat, color : UIColor = .black) {
        
        let textFont = UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: 16.0)
        let attributedString = NSMutableAttributedString(string: str)
        for attributedText in attributedStr {
            let range = (str as NSString).range(of: attributedText)
            attributedString.addAttribute(NSAttributedString.Key.font, value: textFont , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            
            self.attributedText = attributedString
        }
    }
    
    func setAttributedStringWithLineSpacing(str: String, spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: str)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    func setAttributed(text: String, textFont: String, textFontSize: CGFloat, fullString: String, normalTextFont: String, normalTextFontSize: CGFloat) {
        
        let textFont = UIFont(name: textFont, size: textFontSize) ?? UIFont.systemFont(ofSize: 16.0)
        let normalTextFont = UIFont(name: normalTextFont, size: normalTextFontSize) ?? UIFont.systemFont(ofSize: 16.0)

        let attributedText = NSMutableAttributedString(string: text, attributes:[NSAttributedString.Key.font: textFont])
        attributedText.append(NSAttributedString(string: fullString, attributes:[NSAttributedString.Key.font: normalTextFont]))

        self.attributedText = attributedText
    }
    
    /// This function will be used to setup text with diffrect dynamic attributes. like, to make particular text highlighted
    func setAttributeText(mainString: String, stringFirst: String, stringSecond: String? = "", alignment: NSTextAlignment = .center, stringFirstTextColor: UIColor = .blue, stringSecondTextColor: UIColor = .blue) {
        
        let underlineAttriString = NSMutableAttributedString(string: mainString)
        let range1 = (mainString as NSString).range(of: stringFirst)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 17), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: stringFirstTextColor, range: range1)
        
        underlineAttriString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: range1)
        
        let range2 = (mainString as NSString).range(of: stringSecond!)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 17), range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: stringSecondTextColor, range: range2)
        
        let rangeFinal = (mainString as NSString).range(of: mainString)
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 4
        paraStyle.alignment = alignment
        let attributes = [NSAttributedString.Key.paragraphStyle : paraStyle]
        underlineAttriString.addAttributes(attributes, range: rangeFinal)
        
        self.attributedText = underlineAttriString
    }
    
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false, completionHandler: @escaping (() -> Void))
    {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(informationIconTapped(_:))))
        
        let iconImg = UIImage(named: imageName)
            
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = iconImg
        
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(NSAttributedString(string: "  "))
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
        
        informationIconOnTapBlock = { () in
            completionHandler()
        }
    }
    
    @objc fileprivate func informationIconTapped(_ sender: UITapGestureRecognizer) {
        
        if let attributedString = self.attributedText {
            attributedString.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributedString.length), options: []) { (value, range, stop) in
                if let attachment = value as? NSTextAttachment {
                    if attachment.image != nil {
                        if informationIconOnTapBlock != nil {
                            informationIconOnTapBlock()
                        }
                    }
                }
            }
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
