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
    var id: Int = 0
    var popularity: Double?
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        id              = dictionary["id"]              as! Int
        
        popularity      = dictionary["popularity"]      as? Double
    
        title           = dictionary["title"]           as? String
        backdrop_path   = dictionary["backdrop_path"]   as? String
        tagline         = dictionary["tagline"]         as? String
        poster_path     = dictionary["poster_path"]     as? String
        overview        = dictionary["overview"]        as? String
    
    }
    
    
    
    func fullImagePath(posterPath: String, width: Int) -> String {
        return "https://image.tmdb.org/t/p/w" + width.description + posterPath
    }
    
    static func searchMoviesUrl() -> String {
        return "https://api.themoviedb.org/3/search/movie"
    }
    
    static func loadMovieUrl(movieId: Int) -> String {
        let url = "https://api.themoviedb.org/3/movie/" + movieId.description
        //print(url)
        return url
    }
    
    static func checkForTrailersUrl(movieId: Int) -> String {
        let url = "https://api.themoviedb.org/3/movie/" + movieId.description + "/videos"
        //print(url)
        return url        
    }
}