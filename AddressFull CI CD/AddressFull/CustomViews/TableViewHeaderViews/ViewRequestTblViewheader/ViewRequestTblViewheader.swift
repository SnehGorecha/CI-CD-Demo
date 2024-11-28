//
//  RequestTblViewheader.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class RequestTblViewheader: UIView {

    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_title: AFSemiBoldLight!
    
    
    //MARK: HEADER VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }

    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.bg_view.backgroundColor = AppColor.light_gray()
        self.bg_view.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 4.0)
    }
    
    func dataSetup(title: String) {
        self.lbl_title.text = title
    }
}
