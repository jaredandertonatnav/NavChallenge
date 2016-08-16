//
//  MovieTrailer.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/15/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import Foundation
class MovieTrailer {
    var id, key, name, site: String?
    
    var popularity: Double?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
    
        id      = dictionary["id"] as? String
        key     = dictionary["key"] as? String
        name    = dictionary["name"] as? String
        site    = dictionary["site"] as? String
    
    }
    
    
}