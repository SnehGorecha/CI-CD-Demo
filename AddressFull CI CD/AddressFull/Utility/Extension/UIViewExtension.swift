//
//  UIViewExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit


extension UIView {
    
    /// This function will used to setup any control to rounded by default and if specified value is greater then 0.0 then according to that that particualar control will be rounded
    
    private static var no_data_label = UILabel()
    
    func makeRounded(radius: Double = 0.0) {
        self.layer.cornerRadius = radius > 0.0 ? radius : self.frame.size.width / 2.0
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    func setupLayer(borderColor: UIColor = .clear, borderWidth: CGFloat = 0.0, cornerRadius: CGFloat = 0.0) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func setCorner(radius: CGFloat, toCorners: UIRectCorner) {
        
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: toCorners, cornerRadii: CGSize(width: radius, height:  radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    
    /// Use this function to setup navigation bar in any view
    func navigationBarSetup(title: String = "",
                            isWithBackOption: Bool? = nil,
                            isWithRightOption: Bool = false,
                            isWithQROption: Bool = true,
                            title_font_size : CGFloat = 18,
                            right_image : String? = nil,
                            _ didButtonLeftPressedBlock : (() -> Void)? = nil,
                            _ didButtonRightPressedBlock : (() -> Void)? = nil)
    {
        
        if self.subviews.count > 0 {
            self.subviews.forEach { views in
                DispatchQueue.main.async {
                    views.removeFromSuperview()
                }
            }
        }
        
        let navBar = Bundle.main.loadNibNamed("CustomNavigationBar", owner: self)![0] as! CustomNavigationBar
        navBar.lbl_title.text = title
        navBar.lbl_title.font = UIFont(name: AppFont.helvetica_regular, size: title_font_size)
        navBar.isWithBackOption = isWithBackOption
        navBar.isWithRightOption = isWithRightOption
        navBar.isWithQROption = isWithQROption
        navBar.right_image = right_image
        navBar.frame = self.bounds
        
        if let didButtonLeftPressedBlock = didButtonLeftPressedBlock {
            navBar.didButtonLeftPressedBlock = didButtonLeftPressedBlock
        }
        
        if let didButtonRightPressedBlock = didButtonRightPressedBlock {
            navBar.didButtonRightPressedBlock = didButtonRightPressedBlock
        }
        
        
        let sync_label_view = UIView(frame: self.bounds)
        let sync_label = UILabel(frame: CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width - 10, height: self.bounds.height))
        sync_label.textAlignment = .center
        sync_label.numberOfLines = 0
        sync_label.text = LocalText.Synchronization().profile_data_synchronization()
        sync_label.textColor = .white
        sync_label.font = UIFont(name: AppFont.helvetica_bold, size: 14)
        sync_label_view.backgroundColor = AppColor.primary_green()
        sync_label_view.addSubview(sync_label)
        
        
        DispatchQueue.main.async {
            self.addSubview(GlobalVariables.shared.sync_data_completed ? navBar : sync_label_view)
        }
    }
    
    
    /// Use this function to show loading indicator in any view
    func showProgressBar() {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.frame = self.bounds
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)
            self.isUserInteractionEnabled = false
        }
    }
    
    
    /// Use this function to hide loading indicator from any view
    func hideProgressBar() {
        DispatchQueue.main.async {
            self.subviews.forEach { view in
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
            self.isUserInteractionEnabled = true
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func resignRespondersInView() {
        for subview in self.subviews {
            if let textField = subview as? UITextField {
                textField.resignFirstResponder()
            } else if let textView = subview as? UITextView {
                textView.resignFirstResponder()
            }
            subview.resignRespondersInView()
        }
    }
}
