//
//  UIView+NavChallenge.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/15/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSizeZero
        self.clipsToBounds = false
    }
}
