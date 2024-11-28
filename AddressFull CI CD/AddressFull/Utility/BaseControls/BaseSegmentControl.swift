//
//  BaseSegmentControl.swift
//  AddressFull
//
//  Created by MacBook Pro  on 21/11/23.
//

import UIKit

class BaseSegmentControl: UISegmentedControl {

    var un_selected_color : UIColor = .white
    var selected_color : UIColor = AppColor.primary_green()
   
    
    // MARK: SEGMENT CONTROL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
    
        self.selectedSegmentTintColor = selected_color
        self.tintColor = un_selected_color
        
        let selectedTextAttributes: [
            NSAttributedString.Key: Any] = [
                .font: UIFont(name: AppFont.helvetica_bold, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0),
                .foregroundColor: UIColor.white
            ]
        
        let unselectedTextAttributes: [
            NSAttributedString.Key: Any] = [
                .font: UIFont(name: AppFont.helvetica_regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0),
                .foregroundColor: UIColor.black
            ]
        
        self.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
        self.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        self.makeWhiteBackground()
    }
    
    
    // SET WHITE BACKGROUND
    func makeWhiteBackground(){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments-1)  {
                    let backgroundSegmentView = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
