//
//  UIApplicationExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import Foundation
import UIKit

extension UIApplication {
    
    
    /// This function will return top view controller or tap controller or navigation controller, which is currently at top index of screen stack
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    /// Recursive method to find the nearest parent tab bar controller
    class func findTabBarController(controller: UIViewController? = topViewController()) -> UITabBarController? {
        if let tabBarController = controller?.tabBarController {
            return tabBarController
        } else if let navigationController = controller?.navigationController {
            return findTabBarController(controller: navigationController)
        } else if let parent = controller?.parent {
            return findTabBarController(controller: parent)
        }
        return nil
    }
}

