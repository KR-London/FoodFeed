//
//  FeedViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 28/08/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FeedViewController:
    AVPlayerViewController,
    StoryboardScene {
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!
    fileprivate var isPlaying: Bool!
    
    var mainImage = UIImageView()
    
    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController{
        let viewController = FeedViewController.instantiate ( )
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.image = UIImage(named: "pineapple.jpeg")
        layoutSubviews()
    }
    
    func layoutSubviews(){
        let margins = view.layoutMarginsGuide
        
        self.view.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: margins.topAnchor),
            mainImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            mainImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
    }

}

