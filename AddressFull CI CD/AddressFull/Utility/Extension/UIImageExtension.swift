//
//  UIImageExtension.swift
//  AddressFull
//
//  Created by MacBook Pro  on 21/11/23.
//

import Foundation
import UIKit


extension UIImage {
    // Helper method to create a UIImage from a UIColor
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}


extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
            
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.draw(in: CGRectMake(0, 0, self.size.width, self.size.height))
        
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        UIGraphicsEndImageContext()
        
        return normalizedImage;
        
    }
    
}
