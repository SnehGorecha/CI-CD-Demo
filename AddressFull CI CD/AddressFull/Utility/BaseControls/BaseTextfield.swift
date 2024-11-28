//
//  BaseTextfield.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


/// BaseTextfield class will used to setup custom button with customisation, Like, Font related thing UITextField's UI changes
class BaseTextfield: UITextField, UITextFieldDelegate {
    
    var didShouldChangeCharactersInTextfieldBlock : ((_ textField: UITextField, _ fullString: String) -> Void)!
    
    /// Padding - variable will used to set space between text and UITextField
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    var section = 0
    var row = 0
    var max_text_limit = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
        self.delegate = self
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        if let name = font?.fontName, let size = font?.pointSize {
            
            if DeviceSize.IS_IPHONE_4_5_5S_SE_5C {
                self.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6_7_6S_7_8 {
                self.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6P_7P_8PFAMILY {
                self.font = UIFont(name: name, size: size + 1.0)
            }
        }
    }
    
    func setupUI() {
        self.setupLayer(cornerRadius: 14)
        self.backgroundColor = AppColor.light_gray()
        self.set(strFont: AppFont.helvetica_regular)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        AutoLock.shared.startInactivityTimer()
        
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        if self.didShouldChangeCharactersInTextfieldBlock != nil {
            self.didShouldChangeCharactersInTextfieldBlock(textField, currentText)
        }
        
        if self.max_text_limit != 0 {
            return currentText.count <= self.max_text_limit
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder() 
        return true
    }
}

class BasePoppinsRegularTextField: BaseTextfield {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup(fontSize : CGFloat = 16.0) {
        self.font = UIFont(name: AppFont.helvetica_regular, size: fontSize)
    }
}


