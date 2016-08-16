//
//  NavigationController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/15/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class NavigationController:UINavigationController {
    override func viewDidLoad() {
        makeBarTransparent()
    
        

        
    }
    
    func makeBarTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        self.navigationBar.barTintColor             = UIColor.whiteColor()
        self.navigationBar.tintColor                = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes      = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // removing shadow
        UINavigationBar.appearance().shadowImage    = UIImage()
    }
    
}

