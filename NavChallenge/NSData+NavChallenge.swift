//
//  NSData+NavChallenge.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/13/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
extension NSData {
    class func getFromCachedFileOrUrl(urlString: String, completion: ((NSData) -> Void)) {
        if let url = NSURL(string: urlString) {
            if let prefix = url.URLByDeletingPathExtension?.lastPathComponent {
                if let ext = url.pathExtension {

                    let cacheFileName = prefix + "." + ext
                    let storePath = NSHomeDirectory().stringByAppendingString("/Documents/").stringByAppendingString(cacheFileName)
                    
                    if(NSFileManager.defaultManager().fileExistsAtPath(storePath)) {
                        let cachedData = NSData(contentsOfFile: storePath)
                        //print("cached: " + urlString)
                        
                        completion(cachedData!)
                        
                        // check for newer versions
                        
                    } else {
                        let request = NSURLRequest(URL: url)
                        //print("downloading: " + urlString)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                            if let dataToCache = data as NSData? {
                                
                                 let res: NSHTTPURLResponse = response as! NSHTTPURLResponse
                                 if(res.statusCode == 200) {
                                    dataToCache.writeToFile(storePath, atomically: true)
                                    completion(dataToCache)
                                 }
                            }
                        }
                    }
                }
            }
        }
        return
    }
}
