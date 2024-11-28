//
//  SingleLabelTblViewHeader.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class SingleLabelTblViewHeader: UIView {

    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var lbl_title: UILabel!
    
    
    // MARK: HEADER VIEW SETUP
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: CUSTOM FUNCTIONS
    
    func setupData(title: String,font : String = AppFont.helvetica_regular, background_color : UIColor = AppColor.primary_gray()) {
        
        self.lbl_title.font = UIFont(name: font, size: 16)
        self.backgroundColor = background_color
        
        if title.contains("*")  {
            self.lbl_title.setAttributedString(str: title, attributedStr: ["*"], font: AppFont.helvetica_regular, size: 16, color: .red)
        } else {
            self.lbl_title.text = title
        }
    }
}
