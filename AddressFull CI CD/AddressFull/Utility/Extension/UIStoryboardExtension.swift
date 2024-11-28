//
//  UIStoryboardExtension.swift
//  Authentication
//
//  Created by MacBook Pro  on 14/09/23.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    
    /// This functions will return "Splash" storyboard's reference
    func splash() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.splash.rawValue, bundle: nil)
    }
    
    /// This functions will return "onboarding" storyboard's reference
    func onboarding() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.onboarding.rawValue, bundle: nil)
    }
    
    /// This functions will return "Authentication" storyboard's reference
    func authentication() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.authentication.rawValue, bundle: nil)
    }
    
    /// This functions will return "Main" storyboard's reference
    func main() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
    }
    
    /// This functions will return "Home" storyboard's reference
    func home() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.home.rawValue, bundle: nil)
    }
    
    /// This functions will return "Organization" storyboard's reference
    func organization() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.organization.rawValue, bundle: nil)
    }
    
    /// This functions will return "Settings" storyboard's reference
    func settings() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.settings.rawValue, bundle: nil)
    }
    
    /// This functions will return "Profile" storyboard's reference
    func profile() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.profile.rawValue, bundle: nil)
    }
    
    /// This functions will return "Scanner" storyboard's reference
    func scanner() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.scanner.rawValue, bundle: nil)
    }
    
    /// This functions will return "DocumentViewer" storyboard's reference
    func documentViewer() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.documentViewer.rawValue, bundle: nil)
    }
    
    /// This functions will return "Notification" storyboard's reference
    func notification() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.notification.rawValue, bundle: nil)
    }
    
    /// This functions will return "Popup" storyboard's reference
    func popup() -> UIStoryboard {
        return UIStoryboard(name: Storyboard.popup.rawValue, bundle: nil)
    }
}
