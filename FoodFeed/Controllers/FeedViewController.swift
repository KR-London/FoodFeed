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
    UIViewController,
    StoryboardScene {
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!
    var Label = UILabel()
    
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
        if let image = feed.image {
            mainImage.image = UIImage(named: image)
        }
        
        let myGif = UIImage()
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
        
        if feed.text == nil{
            Label.isHidden = true
        }
        else{
            view.backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
            Label = UILabel(frame: self.view.frame)
            Label.text = feed.text
           // self.contentOverlayView?.addSubview(Label)
            view.addSubview(Label)
            Label.textAlignment = .center
            Label.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
            Label.lineBreakMode = .byWordWrapping
            Label.numberOfLines = 4
            Label.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
            Label.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
            view.bringSubviewToFront(Label)
            
        }
        
    }

}

