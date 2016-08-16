//
//  UIViewController+NavChallenge.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/12/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
extension UIViewController {
    func httpManager() -> AFHTTPRequestOperationManager {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).httpManager
    }
    
    
    func handleHttpFailure(operation: AFHTTPRequestOperation, error: NSError) {
        
        if(operation.cancelled) {
            return
        }
    
        if(error.code != 0) {
            switch(error.code) {
                case NSURLErrorTimedOut:
                    self.handleHttpRequestTimeout(operation)
                    return
                default:
                    if(operation.response != nil) {
                        /*switch(operation.response.statusCode) {
                            case 400:
                                self.handleHttpFailureCode400(operation)
                                break
                            case 401:
                                self.handleHttpFailureCode401(operation)
                                break
                            case 402:
                                self.handleHttpFailureCode402(operation)
                                break
                            case 403:
                                self.handleHttpFailureCode403(operation)
                                break
                            case 404:
                                self.handleHttpFailureCode404(operation)
                                break
                            case 405:
                                self.handleHttpFailureCode405(operation)
                                break
                            case 409:
                                self.handleHttpFailureCode409(operation)
                                break
                            case 410:
                                self.handleHttpFailureCode410(operation)
                                break
                            case 500:
                                self.handleHttpFailureCode500(operation)
                                break
                            default:
                                self.handleHttpFailureCodeUnspecified(operation)
                                break
                        }*/
                        self.handleHttpFailureCodeUnspecified(operation)
                    } else {
                        self.handleHttpRequestUnKnownFailure(operation)
                        return
                    }
            }
        }
    }
    
    func handleHttpRequestTimeout(operation: AFHTTPRequestOperation) {
        // alert the user to a server timeout
        let alertController = AlertController(
            title: "Request Timed Out",
            message: "The server took too long to respond. Please try again later.",
            preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func handleHttpFailureCodeUnspecified(operation: AFHTTPRequestOperation) {
        // unspecified error
        let alertController = AlertController(title: "This is embarrassing...", message: "There was an error we didn't handle. Please try again or contact us for support.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            //
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    func handleHttpRequestUnKnownFailure(operation: AFHTTPRequestOperation) {
        // unknown error
        let alertController = AlertController(
            title: "Server Error",
            message: "The was an error communicating with the server. Please try again later of contact us for support.",
            preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }

}
