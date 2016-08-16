//
//  DetailViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/14/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class DetailViewController: ViewController {
    var movieId: Int?
    var movie: Movie?
    var backgroundGradientsApplied: Bool = false
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovie()
    }
    
    func configureView() {
        if let backdropImagePath = movie?.backdrop_path {
            setBackgroundImageWithUrl(backdropImagePath)
        } else if let posterPath = movie?.poster_path {
            setBackgroundImageWithUrl(posterPath)
        }
        self.applyBackgroundGradient()
        
        
        /*
        
        */
        
        movieTitleLabel.text = ""
        if let movieTitle = movie?.title {
            movieTitleLabel.text = movieTitle
            movieTitleLabel.addShadow()
        }
    }
    
    func applyBackgroundGradient() {
        if backgroundGradientsApplied == true {
            return
        }
        
        let blackColor = UIColor(white: 0, alpha: 1)
        let clearColor = UIColor.clearColor()
        
        let w = UIScreen.mainScreen().bounds.size.width + 5
        let h = backdropImageView.frame.height
        let h2 = h * 0.4
        
        
        let topLayer = CAGradientLayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: w, height: 65)
        
        topLayer.colors = [blackColor.CGColor, clearColor.CGColor]
        
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: w, height: h)
        
        //let clearColor = UIColor.redColor()
        layer.colors = [clearColor.CGColor, blackColor.CGColor]
        layer.startPoint = CGPointMake(0, 0.2);
        layer.endPoint = CGPointMake(0, 1);

        backdropImageView?.layer.addSublayer(layer)
        backdropImageView?.layer.addSublayer(topLayer)
        
        backgroundGradientsApplied = true
    }
    
    func setBackgroundImageWithUrl(imageUrl: String) {
        let imageUrl = movie?.fullImagePath(imageUrl, width: 640)

        
        NSData.getFromCachedFileOrUrl(imageUrl!, completion: { (imageData) in
            let downloadedImage                 = UIImage(data: imageData)
            
            self.backdropImageView.image        = downloadedImage
            self.backdropImageView.contentMode  = .ScaleAspectFill
            self.backdropImageView.setNeedsLayout()
            self.backdropImageView.setNeedsDisplay()
        })
    }
    
    func loadMovie() {
        self.httpManager().GET(
            Movie.loadMovieUrl(movieId!),
            parameters: loadMovieParameters(),
            success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) in
                
                
                do {
                    let json    = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: .AllowFragments)
                    self.movie  = Movie.init(json as! Dictionary<String, AnyObject>)
                } catch {
                    //print("Error \(error)")
                }
                self.configureView()
                
                
                
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) in
                self.handleHttpFailure(operation!, error: error)
            }
        )
    }
    
    func loadMovieParameters() -> Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        params["api_key"]   = Constants.TheMovieDbApiKey
        return params
    }
    
    // let imageUrl = movie.fullImagePath(posterPath, 185)
    
    
}
