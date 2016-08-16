//
//  ViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/12/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var edgeInsets: UIEdgeInsets?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        defaultBackButton()
    }
    
    func defaultBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }


    


    func prepareTableViewForKeyboard() {
        edgeInsets = self.tableView?.contentInset
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: edgeInsets!.top, left: 0, bottom: keyboardSize.height, right: 0)
            self.tableView?.contentInset = contentInsets
            self.tableView?.scrollIndicatorInsets = contentInsets

        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.tableView?.contentInset = edgeInsets!
        self.tableView?.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

