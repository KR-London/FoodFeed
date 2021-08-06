//
//  uiTestViewController.swift
//  FoodFeed
//

import UIKit
import SoftUIView

class uiTestViewController: UIViewController, FeedViewInteractionDelegate {
    var delegate: CommentProviderDelegate?
    
    var feedView = PostView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = view.bounds

        feedView  = PostView(frame: self.view.frame, feed: Feed(id: 99, state: .poll(caption: "Best jam?", votea: "Strawberry", voteb: "Raspberry", votec: "Cherry", hashtag: nil, who: .Guy)    )    )
        //feedView.interactionView.isHidden = true
        feedView.avatarView.isHidden = false
      //  feedView.avatarView.imageView.image = botUser.guy.profilePic
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
