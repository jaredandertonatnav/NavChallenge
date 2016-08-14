//
//  MovieModel.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/13/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import Foundation
class Movie {
    var title, backdrop_path, tagline, poster_path, overview: String?
    var id: Int?
    var popularity: Double?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        id              = dictionary["id"] as? Int
        
        popularity      = dictionary["popularity"] as? Double
    
        title           = dictionary["title"] as? String
        backdrop_path   = dictionary["backdrop_path"] as? String
        tagline         = dictionary["tagline"] as? String
        poster_path     = dictionary["poster_path"] as? String
        overview        = dictionary["overview"] as? String
        
        
    }
    
    
}