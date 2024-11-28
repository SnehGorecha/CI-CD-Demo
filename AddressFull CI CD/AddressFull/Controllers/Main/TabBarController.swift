//
//  TabBarController.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var upper_line_view: UIView!
    var upper_line_black_view: UIView!
    let spacing: CGFloat = 12
    var arr_selected_icon = [AssetsImage.home_selected,AssetsImage.my_trusted_selected,AssetsImage.activity_log_selected,AssetsImage.setting_selected]
    var arr_unselected_icon = [AssetsImage.home_unselected,AssetsImage.my_trusted_unselected,AssetsImage.activity_log_unselected,AssetsImage.setting_unselected]
    
    
    // MARK: - TAB BAR CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarSetup()
    }
    
    // MARK: - COMMON FUNCTION
    
    func tabBarSetup() {
        
        self.tabBar.layer.cornerRadius = 14
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        for i in 0..<self.arr_selected_icon.count {
            let myTabBarItem = (self.tabBar.items?[i])! as UITabBarItem
            myTabBarItem.image = UIImage(named: arr_unselected_icon[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem.selectedImage = UIImage(named: arr_selected_icon[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem.title = ""
            myTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
