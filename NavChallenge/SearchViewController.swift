//
//  SearchViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/12/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class SearchViewController: ViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var results:[Movie] = []
    var resultsLoadPage: Int = 0
    var resultsPageCount: Int = 0
    var query: NSString = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareTableViewForKeyboard()
    }
    
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
        
        return cell!
    }
    
    
    func searchMoviesUrl() -> String {
        return "https://api.themoviedb.org/3/search/movie"
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
        tableView.reloadData()
        resultsLoadPage     = 0
        resultsPageCount    = 0
    }
    
    func loadNextPage() {
        resultsLoadPage += 1
        
        self.httpManager().GET(
            self.searchMoviesUrl(),
            parameters: self.searchMoviesParameters(),
            success: { (operation: AFHTTPRequestOperation, responseObject: AnyObject) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
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
                        print("pageNum: \(pageNum)")
                        // the api is the source of truth
                        self.resultsLoadPage = pageNum;
                    }
                    if let pageNumCount = json.objectForKey("total_pages") as? Int {
                        print("pageNumCount: \(pageNumCount)")
                        self.resultsPageCount = pageNumCount;
                    }
                } catch {
                    //print("Error \(error)")
                }
                //self.results = tmpMovie
                let tmpResults  = self.results
                self.results    = tmpResults + tmpMovie
                self.tableView.reloadData()
                
                //var IndexPathOfLastRow = NSIndexPath(forRow: tmpResults.count - 1, inSection: 0)
                //self.tableView.insertRowsAtIndexPaths([IndexPathOfLastRow], withRowAnimation: UITableViewRowAnimation.Left)
                
                
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError) in
                // 
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //self.handleHttpFailure(operation, error: error)
            }
        )
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            if text.characters.count > 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                query = text
                
                self.httpManager().operationQueue.cancelAllOperations()
                self.resetResults()
                self.loadNextPage()
            } else {
                
            }
        }
        //print(searchText)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == results.count - 1 && resultsLoadPage < resultsPageCount {
            loadNextPage()
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
}
