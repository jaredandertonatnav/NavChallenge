//
//  SearchViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/12/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class SearchViewController: ViewController, UISearchBarDelegate, /*UITableViewDelegate, UITableViewDataSource,*/ UICollectionViewDelegate, UICollectionViewDataSource {
    
    var results:[Movie] = []
    var resultsLoadPage: Int = 0
    var resultsPageCount: Int = 0
    var query: NSString = ""
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.prepareTableViewForKeyboard()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func searchMoviesParameters() -> Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        
        params["api_key"]   = Constants.TheMovieDbApiKey
        params["query"]     = query
        params["page"]      = resultsLoadPage
        
        return params
    }
    
    func resetResults() {
        results.removeAll()
        //tableView.reloadData()
        resultsLoadPage     = 0
        resultsPageCount    = 0
    }
    
    func loadNextPage() {
        // increment the page counter for the next page call
        resultsLoadPage += 1
        
        self.httpManager().GET(
            Movie.searchMoviesUrl(),
            parameters: self.searchMoviesParameters(),
            success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) in
                
                var tmpMovie: [Movie] = []
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: .AllowFragments)
                    if let movies = json.objectForKey("results") as? NSArray {
                        for movieData in movies {
                            let movie = Movie.init(movieData as! Dictionary<String, AnyObject>)
                            tmpMovie.append(movie)
                        }
                    }
                    if let pageNum = json.objectForKey("page") as? Int {
                        // the api is the source of truth, so overwrite the page counter variable
                        self.resultsLoadPage = pageNum;
                    }
                    if let pageNumCount = json.objectForKey("total_pages") as? Int {
                        self.resultsPageCount = pageNumCount;
                    }
                } catch {
                    //print("Error \(error)")
                }
                let tmpResults  = self.results
                self.results    = tmpResults + tmpMovie
                //self.tableView.reloadData()
                self.collectionView.reloadData()
                
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) in
                self.handleHttpFailure(operation!, error: error)
            }
        )
    }
    
    /*
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsCell")
        let movie = results[indexPath.item]
        if let title = movie.title {
            cell?.textLabel?.text = title
        }
        
        if let posterPath = movie.poster_path {
            let imageUrl = movie.fullImagePath(posterPath, width: 185)
        
            NSData.getFromCachedFileOrUrl(imageUrl, completion: { (imageData) in
                let downloadedImage             = UIImage(data: imageData)
                cell?.imageView?.contentMode    = .ScaleAspectFill
                cell?.imageView?.image          = downloadedImage
                cell?.imageView!.setNeedsLayout()
                cell?.imageView!.setNeedsDisplay()
            })
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == results.count - 1 && resultsLoadPage < resultsPageCount {
            loadNextPage()
        }
    }*/
    
    
    
    
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchResultsCollectionCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        
        let movie = results[indexPath.item]
        cell.movie = movie
        if let title = movie.title {
            cell.movieTitleLabel.text = title
            cell.movieTitleLabel.addShadow()
        }
        
        /*let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.init(rawValue: 1)!)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        cell.titleView.insertSubview(blurEffectView, atIndex: 0)*/
        
        
        cell.backgroundImageView.image = UIImage(named: "MoviePlaceHolder")
        //if let imagePath = movie.backdrop_path {
        if let imagePath = movie.poster_path {
            let imageUrl = movie.fullImagePath(imagePath, width: 185)
        
            NSData.getFromCachedFileOrUrl(imageUrl, completion: { (imageData) in
                let downloadedImage             = UIImage(data: imageData)
                cell.backgroundImageView.image  = downloadedImage
                cell.backgroundImageView.setNeedsDisplay()
                
            })
        }
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == results.count - 1 && resultsLoadPage < resultsPageCount {
            loadNextPage()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        // dynamically size the cells, for consistent size and spacing across different devices
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let spacing = Float(8.0)
        var mult = Float(1.5)
        if(UIDevice.isSixPlus()) {
            // hack for 6 plus
            mult = Float(2.5)
        }
        
        let positiveSpace = Float(screenSize.size.width) - (spacing * mult)
        let w = positiveSpace / 2.0
        let h = w
        
        return CGSizeMake(CGFloat(w), CGFloat(h))
    }

    
    

    
    
    
    
    
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            if text.characters.count > 0 {
                query = text
                
                self.httpManager().operationQueue.cancelAllOperations()
                self.resetResults()
                self.loadNextPage()
            } else {
                
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadMovieSegue" {
        
            //let indexPath   = self.tableView.indexPathForCell(sender as! UITableViewCell)
            
            let indexPath   = self.collectionView.indexPathForCell(sender as! SearchCollectionViewCell)
            let movie       = results[(indexPath?.item)!]
            let vc          = segue.destinationViewController as! DetailViewController
            vc.movie        = movie
            
            // stop the search bar from being the first responder, 
            // so when navigating back, the scroll point doesn't change
            self.view.endEditing(true)
            
            return
        }
    }
}
