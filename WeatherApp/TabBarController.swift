//
//  TabBarController.swift
//  WeatherApp
//
//  Created by Henrik Frank on 2020-02-12.
//  Copyright © 2020 Henrik Frank. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var currentTab: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if self.tabBar.selectedItem?.tag == currentTab {
            
            return false
        }
        
        currentTab = self.tabBar.selectedItem?.tag ?? -1
        
        return true
    }
}
