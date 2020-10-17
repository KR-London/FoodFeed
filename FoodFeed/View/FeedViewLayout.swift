//
//  FeedViewLayout.swift
//  FoodFeed
//
//  Created by Kate Roberts on 12/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit

protocol FeedViewInteractionDelegate: class {
    func likeTapped(_ sender: UIButton)
    var delegate: CommentProviderDelegate? { get set }
    func dontLikeThis(sender: UIView)
}

// button that has an "activated / deactivated" state

/// Button that has an "activated / deactivated" state and a callback to react to a change in that state
class ToggleButton: UIButton {
    var isOn: Bool = false {
        didSet {
            // update appearance
            self.tintColor = isOn ? .green : .red
            if isOn {
                self.setImage(selectedImage, for: .normal)
            } else {
                self.setImage(deselectedImage, for: .normal)
            }
        }
    }
    
    var selectedImage: UIImage?
    var deselectedImage: UIImage?
    
    var didToggle: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = UIColor.red
        self.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    @objc func didTap(_ sender: UIButton) {
        self.isOn.toggle()
        self.didToggle?(self.isOn)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


/// A view that plays gifs and can be started and stopped
class GifPlayerView: UIView {
    var isPlaying: Bool = false
    var url: URL?
    init(url: URL? = nil) {
        self.url = url
        super.init(frame: .zero)
        // setup touch interaction for play/pause
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// A view that contains a list of comments and scrolls the latest comments as they update (maybe :) ) [Unimplemented]
class CommentsView: UIView {
    var comments: [Comment] = []
    
    private let tableView: UITableView
    
    override init(frame: CGRect) {
        tableView = UITableView.commentsTableView()
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        tableView = UITableView.commentsTableView()
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // add tableview to view
        // 20 lines of setting properties on tablieview //  UITableViewr.comeent
        // set datasource /
    }
}



extension UITableView {
    static func commentsTableView() -> UITableView {
        let tableView = UITableView()
        // configure / style
        return tableView
    }
}

//
class FeedItemView: UIView {
    private let gifPlayer = GifPlayerView()
    private let likeButton = ToggleButton()
    private let dislikeButton = ToggleButton()
    private let commentsView = CommentsView()
    private let profilePicture = UIImage()// ProfilePicture
    
    var likeButtonTapped: ((Bool) -> Void)?
    var dislikeButtonTapped: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // add everything to view / layout
        likeButton.didToggle = { isOn in
            // do something that affects the feedview
            self.likeButtonTapped?(isOn)
        }
        dislikeButton.didToggle = dislikeButtonTapped
    }
}



extension UIView {
    
    func feedViewLayout(feed: Feed, profilePic: UIImage, sender: UIViewController){
        
        weak var delegate: FeedViewInteractionDelegate?
        
        delegate = sender as! FeedViewInteractionDelegate
        delegate?.dontLikeThis(sender: self)
        
        let margins = self.layoutMarginsGuide
        
        //MARK: Stored image content
        var mainImage = UIImageView()
        if let image = feed.image {
            mainImage.image = UIImage(named: image)
        }
        layoutSubviews()
        if let gifName = feed.gifName {
            do {
                let gif = try UIImage(gifName: gifName)
                mainImage = UIImageView(gifImage: gif, loopCount: -1)
                mainImage.frame = self.bounds
                self.addSubview(mainImage)
            } catch {
                print(error)
            }
        }
        
        self.addSubview(mainImage)
        mainImage.contentMode = .scaleAspectFill
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: margins.topAnchor),
            mainImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            mainImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        //MARK: Auto-generated content
        var characterQuipLabel = UILabel()
        if feed.text == nil{
            characterQuipLabel.isHidden = true
        }
        else{
            self.backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
            characterQuipLabel = UILabel(frame: self.frame)
            characterQuipLabel.text = feed.text
            // self.contentOverlayView?.addSubview(Label)
            self.addSubview(characterQuipLabel)
            characterQuipLabel.textAlignment = .center
            characterQuipLabel.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
            characterQuipLabel.lineBreakMode = .byWordWrapping
            characterQuipLabel.numberOfLines = 4
            characterQuipLabel.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
            characterQuipLabel.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
            bringSubviewToFront(characterQuipLabel)
        }
        
        
        // MARK: Buttons and profile
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.alignment = .center
        buttonStack.contentMode = .scaleAspectFit
        buttonStack.distribution = .equalSpacing
        self.addSubview(buttonStack)
        
        let pic = UIImageView()
        pic.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pic.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pic.layer.cornerRadius = 20
        pic.layer.masksToBounds = true
        pic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pic.layer.borderWidth = 2
        pic.backgroundColor = .white
        pic.contentMode = .scaleAspectFill
        pic.image = profilePic
        buttonStack.addArrangedSubview(pic)
        
        let likeButton = UIButton()
        likeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
       // likeButton.titleLabel!.text = "Like"
        //likeButton.titleLabel!.text = "Dislike"
        if #available(iOS 13.0, *) {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setTitle("Like", for: .normal)
        }
        likeButton.tintColor = UIColor.green
        likeButton.layer.cornerRadius = 50
        buttonStack.addArrangedSubview(likeButton)
        likeButton.addTarget(self, action: #selector(likeTapped(_: )), for: .touchUpInside)
        
        let dislikeButton = UIButton()
        dislikeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        dislikeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dislikeButton.titleLabel!.text = "Dislike"
        if #available(iOS 13.0, *) {
            dislikeButton.setImage(UIImage(systemName: "hand.raised.slash"), for: .normal)
        } else {
            dislikeButton.setTitle("X", for: .normal)
        }
        dislikeButton.tintColor = UIColor.green
        dislikeButton.layer.cornerRadius = 50
        buttonStack.addArrangedSubview(dislikeButton)
       // button.addTarget(self, action: #selector(dislikeTapped(_:)), for: .touchUpInside)


        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            buttonStack.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.1)
        ])
    }

    //@objc func like(_ sender: UIButton){
//        print("This works")
//    }
    // Notes a like
    // toggles the value in user defaults, and changes appearance of button to match.
    @objc func likeTapped(_ sender: UIButton) {
        
        print("I like this")
        let defaults = UserDefaults.standard

        var liked = defaults.array(forKey: "Liked") as? [String]

        if #available(iOS 13.0, *) {
            if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
            {
                sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
               // feed.liked = true
                ///FIXME: Likes not persisiting(feed.gif as String)
                //let ref =  feed.image ?? feed.text ??  ""

//                if let _ = liked {
//                    liked = liked! + [ref]
//                }
//                else{
//                    liked =  [ref]
//                }

                defaults.set( liked , forKey: "Liked")

            }
            else
            {
                sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                sender.tintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
               // feed.liked = false

                //FIXME: feed.gif ?? to persisist likes
//                let ref = feed.image ?? feed.text ??  ""
//
//                if let _ = liked {
//                    liked = liked!.filter{ $0 != ref}
//                }
//                defaults.set( liked , forKey: "Liked")
            }
        } else {
            //FIXME: How to handle likes in iOS12
        }

        //TODO: How to persist likes
        //        let dataToSave : [String: Any] = ["name": feed.originalFilename, "liked": feed.liked]
        //
        //        let docRef = userRef.document(Auth.auth().currentUser?.email ?? "Anonymous" + String(Int.random(in: 1...1000))).collection("likes").document(feed.originalFilename)
        //
        //        docRef.setData(dataToSave){
        //            (error) in
        //            if let error = error {
        //                print("Crumbs!")
        //                print( error.localizedDescription )
        //            }
        //            else{
        //                print("Data has been saved")
        //            }
        //        }
    }

}
