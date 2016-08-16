//
//  PlayTrailerViewController.swift
//  NavChallenge
//
//  Created by Jared Anderton on 8/16/16.
//  Copyright © 2016 andertondev. All rights reserved.
//

import UIKit
class PlayTrailerViewController: ViewController, YTPlayerViewDelegate {

    var movieTrailer: MovieTrailer?
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let trailer = movieTrailer {
            self.playerView.loadWithVideoId(trailer.key!)
            self.playerView.delegate = self
        }
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    
    
}
