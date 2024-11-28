//
//  BaseIOSDropDown.swift
//  AddressFull
//
//  Created by Sneh on 11/27/23.
//

import Foundation
import iOSDropDown


class BaseIOSDropDown : DropDown {
    
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    var section = 0
    var row = 0
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
