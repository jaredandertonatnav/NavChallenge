//
//  SearchCollectionViewCell.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/15/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class SearchCollectionViewCell: UICollectionViewCell {
    var movie: Movie?
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.cornerRadius                 = 6
        self.backgroundImageView?.clipsToBounds = true
        
        
    }
}

