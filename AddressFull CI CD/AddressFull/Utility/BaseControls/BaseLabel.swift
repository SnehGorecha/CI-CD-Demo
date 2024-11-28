//
//  BaseLabel.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import UIKit


/// BaseLabel class will used to setup custom Label with customisation, Like, Font related thing UILabel's UI changes
class AFLabelRegular: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        
        let font = UIFont(name: AppFont.helvetica_regular, size: font?.pointSize ?? 14.0)
        self.setupFontSize(font: font)
    }
}

class AFLabelLight: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        
        let font = UIFont(name: AppFont.helvetica_regular, size: font?.pointSize ?? 14.0)
        self.setupFontSize(font: font)
        self.textColor = AppColor.text_grey_color()
    }
}

class AFSemiBoldLight: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        
        let font = UIFont(name: AppFont.helvetica_bold, size: font?.pointSize ?? 17.0)
        self.setupFontSize(font: font)
    }
}

class AFLabelBold: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        
        let font = UIFont(name: AppFont.helvetica_bold, size: font?.pointSize ?? 17.0)
        self.setupFontSize(font: font)
    }
}

class AFRedactedScriptLabelRegular: UILabel {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        
        let font = UIFont(name: AppFont.redactedScript_regular, size: font?.pointSize ?? 17.0)
        self.setupFontSize(font: font)
    }
}


fileprivate extension UILabel {
    
    func setupFontSize(font : UIFont?) {
        
        if let name = font?.fontName , let size = font?.pointSize {
            
            if DeviceSize.IS_IPHONE_4_5_5S_SE_5C || DeviceSize.IS_IPHONE_4_5_5S_SE_5C {
                self.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6_7_6S_7_8 {
                self.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6P_7P_8PFAMILY {
                self.font = UIFont(name: name, size: size + 1.0)
            }
        }
        
        self.textColor = .black
    }
}
