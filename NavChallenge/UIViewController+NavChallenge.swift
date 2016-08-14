//
//  UIViewController+NavChallenge.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/12/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
extension UIViewController {
    func httpManager() -> AFHTTPRequestOperationManager {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).httpManager
    }

}
