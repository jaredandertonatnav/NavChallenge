//
//  DetailViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/14/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class DetailViewController: ViewController {
    var movie: Movie?
    var movieTrailer: MovieTrailer?
    var backgroundGradientsApplied: Bool = false
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var playTrailerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadMovie()
        
    }
    
    func configureView() {
        if let posterPath = movie?.poster_path {
            setBackgroundImageWithUrl(posterPath)
        }
        
        
        var frame = bannerImageView.frame
        
        if let backdropImagePath = movie?.backdrop_path {
            setBannerImageWithUrl(backdropImagePath)
        } else {
            frame.size.height = 0.00001
        }
        bannerImageView.frame = frame
        
        
        self.applyBackgroundGradient()
        
        
        movieTitleLabel.text = ""
        if let movieTitle = movie?.title {
            movieTitleLabel.text = movieTitle
            movieTitleLabel.addShadow()
        }
        
        overviewLabel.text = ""
        frame = overviewLabel.frame
        if let overview = movie?.overview {
            let size            = rectForText(overview, font: overviewLabel.font, maxSize: CGSizeMake(overviewLabel.frame.width, 500))
            frame.size          = size
            overviewLabel.text  = overview
            overviewLabel.addShadow()
        } else {
            frame.size.height = 0.0
        }
        overviewLabel.frame = frame
        
        playTrailerButton.addShadow()
        
        
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        let size = CGSizeMake(rect.size.width, rect.size.height)
        return size
    }
    
    func applyBackgroundGradient() {
        if backgroundGradientsApplied == true {
            return
        }
        
        let blackColor  = UIColor(white: 0, alpha: 1)
        let clearColor  = UIColor.clearColor()
        let w           = UIScreen.mainScreen().bounds.size.width + 5
        let h           = backdropImageView.frame.height
    
        
        
        let topLayer        = CAGradientLayer()
        topLayer.frame      = CGRect(x: 0, y: 0, width: w, height: 100)
        
        topLayer.colors     = [blackColor.CGColor, clearColor.CGColor]
        
        
        let layer           = CAGradientLayer()
        layer.frame         = CGRect(x: 0, y: 0, width: w, height: h)
        
        layer.colors        = [clearColor.CGColor, blackColor.CGColor]
        layer.startPoint    = CGPointMake(0, 0.0);
        layer.endPoint      = CGPointMake(0, 1);

        //backdropImageView?.layer.addSublayer(layer)
        backdropImageView?.layer.addSublayer(topLayer)
        
        
        
        backgroundGradientsApplied = true
    }
    
    func setBackgroundImageWithUrl(imageUrl: String) {
        let imageUrl = movie?.fullImagePath(imageUrl, width: 640)

        
        NSData.getFromCachedFileOrUrl(imageUrl!, completion: { (imageData) in
            
            let downloadedImage                 = UIImage(data: imageData)
            let blurredDownloadedImage          = downloadedImage?.applyDarkEffect()
            self.backdropImageView.contentMode  = .ScaleAspectFill
            UIView.animateWithDuration(0.5, animations: {
                self.backdropImageView.image        = blurredDownloadedImage
                
                if self.movieTrailer != nil {
                    self.playTrailerButton.alpha = 1.0
                } else {
                    self.playTrailerButton.alpha = 0.0
                }
            })
            
            
            
            
            
            
        })
    }
    
    func setBannerImageWithUrl(imageUrl: String) {
        let imageUrl = movie?.fullImagePath(imageUrl, width: 640)

        
        NSData.getFromCachedFileOrUrl(imageUrl!, completion: { (imageData) in
            let downloadedImage                 = UIImage(data: imageData)
            self.bannerImageView.contentMode    = .ScaleAspectFill
            
            
            
            
            UIView.animateWithDuration(0.5, animations: {
                self.bannerImageView.image      = downloadedImage
                self.bannerImageView.alpha      = 1.0
            })
        })
    }

    func loadMovieParameters() -> Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        params["api_key"]   = Constants.TheMovieDbApiKey
        return params
    }
    
    func loadMovie() {
        self.httpManager().GET(
            Movie.loadMovieUrl(movie!.id),
            parameters: loadMovieParameters(),
            success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) in
                
                
                do {
                    let json    = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: .AllowFragments)
                    self.movie  = Movie.init(json as! Dictionary<String, AnyObject>)
                } catch {
                    //print("Error \(error)")
                }
                self.configureView()
                self.checkForTrailers()
                
                
                
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) in
                self.handleHttpFailure(operation!, error: error)
            }
        )
    }
    
    
    
    func checkForTrailers() {
        self.httpManager().GET(
            Movie.checkForTrailersUrl(movie!.id),
            parameters: loadMovieParameters(),
            success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) in
                
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: .AllowFragments)
                    if let trailers = json.objectForKey("results") as? NSArray {
                        for trailerData in trailers {
                            let trailer = MovieTrailer.init(trailerData as! Dictionary<String, AnyObject>)
                            self.movieTrailer = trailer
                            if let trailerName = trailer.name {
                                if trailerName == "Official Trailer" {
                                    break
                                }
                            }
                            
                        }
                    }
                    
                } catch {
                    //print("Error \(error)")
                }
                self.configureView()
                
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) in
                self.handleHttpFailure(operation!, error: error)
            }
        )
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "playTrailerSegue" {
            if movieTrailer == nil {
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playTrailerSegue" {
            let vc          = segue.destinationViewController as! PlayTrailerViewController
            if let trailer = self.movieTrailer {
                vc.movieTrailer = trailer
            }
            return
        }
    }
    
    
    
    
    
}
