//
//  UITableViewExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import Foundation
import UIKit


extension UITableView {
    
    func removeHeaderTopPadding() {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0.0
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func setProgressView() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        self.backgroundView = spinner
    }
}
