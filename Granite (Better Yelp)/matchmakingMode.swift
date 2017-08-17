//
//  matchmakingMode.swift
//  Granite (Better Yelp)
//
//  Created by Matthew on 8/14/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import FirebaseDatabase
import VideoBackground
import AVKit
import AVFoundation


class MatchmakingViewController : UIViewController {
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
//        let videoPath = Bundle.main.path(forResource: "giphy", ofType: "mp4")
//        let imagePath = Bundle.main.path(forResource: "computer", ofType: "jpg")!
//        let options = VideoOptions(pathToVideo: videoPath!, pathToImage: imagePath, isMuted: false, shouldLoop: true )
//        let videoView = VideoBackground(frame: view.frame, options: options)
//        videoView.tag = 100
//        videoView.isUserInteractionEnabled = true
//        view.addSubview(videoView)
   //      So essentially what we are doing here is that we are configuring the settings for matchmaking mode to hold a video in our matchmaking mode
       
        let videoURL: URL! = Bundle.main.url(forResource: "used", withExtension: "mp4")
        player = AVPlayer(url: videoURL)
        // So in these two lines of codes what we are essentially doing is that we are creating a let constant called video url and what is happening here is that we are creating a pathway to our imported video
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player:player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
    
        player?.play()
        
        // Now we are going to loop the video
        NotificationCenter.default.addObserver(self, selector: #selector(MatchmakingViewController.loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    func loopVideo() {
        player?.seek(to:kCMTimeZero)
        player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.backgroundColor = UIColor.blue
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
       self.view.backgroundColor = UIColor.yellow
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
}
