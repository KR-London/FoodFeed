//
//  uiTestViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 28/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import SoftUIView

class uiTestViewController: UIViewController, FeedViewInteractionDelegate {
    var delegate: CommentProviderDelegate?
    
    var feedView = PostView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = view.bounds

        feedView  = PostView(frame: self.view.frame, feed: Feed(id: 99, state: .poll(caption: "Best jam?", votea: "Strawberry", voteb: "Raspberry", votec: "Cherry", hashtag: nil)    )    )
        //feedView.interactionView.isHidden = true
        feedView.avatarView.isHidden = false
        feedView.avatarView.imageView.image = botUser.guy.profilePic
        feedView.delegate = self
        view = feedView
        
        let profilePicture = UIImageView()
        profilePicture.image = botUser.guy.profilePic
        view.addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6 ),
            profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6),
            profilePicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            profilePicture.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = frame.width/12
        profilePicture.clipsToBounds = true
    }
}
