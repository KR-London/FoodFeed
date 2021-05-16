//
//  YTViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 16/05/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let myView = YTPlayerView()
        
        self.view = myView
        
        let playerVars = [ "rel" : 0, "loop" : 1]
        myView.load(withPlaylistId: "PLPCeSm8EDITr2z9Y6tnTrP3ZsWZKDdMYi", playerVars: playerVars)
        
        //myView.duration(())
        
      //  let playerVars = [ "rel" : 0 ]
// myView.load(withVideoId: "l_NYrWqUR40", playerVars: playerVars)
//        myView.setLoop(true)
//        myView.playVideo()
//        myView.
//        loadVideoById:(nonnull NSString *)videoId
//        startSeconds:(float)startSeconds
//        endSeconds:(float)endSeconds;
       // myView.loadVideo(byId: "l_NYrWqUR40", startSeconds: 2.0, endSeconds: 6.0)
       // myView.playVideo()
        //myView.videoUrl{ ("https://youtu.be/l_NYrWqUR40"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
