//
//  FeedViewLayout.swift
//  FoodFeed
//
//  Created by Kate Roberts on 12/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.



// play/pause
//
//

import UIKit

protocol FeedViewInteractionDelegate: class {
//    func likeTapped(_ sender: UIButton)
    var delegate: CommentProviderDelegate? { get set }
//    func dislikeTapped(_ sender: UIButton)
}

/// A view that plays gifs and can be started and stopped
class MainView: UIView {
    
    var isPlaying: Bool = false
    var feed: Feed
    
    var mainImage = UIImageView()
    private var characterQuipLabel : UILabel?

    
    init(feed: Feed!) {
        self.feed = feed
        super.init(frame: .zero)
        let margins = self.layoutMarginsGuide
        setup(feed: feed)
        layout(margins: margins)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(feed: Feed){
        
        switch feed.state {
            case .text(let text):
                print(text)
                print("December 8")
            default:
                print("default")
        }
        
//        if case let feed.state.text = text {
//            print(text)
//        }
        
//        // Identify what the content of this feed item is, and load the correct view components to display it
//        if let quip = feed.bigtext{
//            characterQuipLabel = UILabel(frame: self.frame)
//            characterQuipLabel!.text = quip
//            addSubview(characterQuipLabel!)
//        }
//        else{
//            //MARK: Stored image content
//            if let image = feed.image {
//                mainImage.image = UIImage(named: image)
//            }
//
//            if let gifName = feed.gifName {
//                do {
//                    let gif = try UIImage(gifName: gifName)
//                    mainImage = UIImageView(gifImage: gif, loopCount: -1)
//                    // mainImage.frame = self.bounds
//                    // self.addSubview(mainImage)
//                } catch {
//                    print(error)
//                }
//            }
//
//            self.addSubview(mainImage)
//
//        }
    }
    
    func layout(margins: UILayoutGuide){
        
        //FIXME: Refactor Layouts
        switch feed.state {
            case .text(let text):
                backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
            
                characterQuipLabel!.text = text
                // self.contentOverlayView?.addSubview(Label)
                characterQuipLabel!.textAlignment = .center
                characterQuipLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
                characterQuipLabel!.lineBreakMode = .byWordWrapping
                characterQuipLabel!.numberOfLines = 4
                characterQuipLabel!.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
                characterQuipLabel!.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
                
                characterQuipLabel!.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    characterQuipLabel!.topAnchor.constraint(equalTo: margins.topAnchor),
                    characterQuipLabel!.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                    characterQuipLabel!.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                    characterQuipLabel!.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
                ])
                
                
                bringSubviewToFront(characterQuipLabel!)
            default:
                       // characterQuipLabel!.isHidden = true
                        mainImage.contentMode = .scaleAspectFill
                        mainImage.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            mainImage.topAnchor.constraint(equalTo: margins.topAnchor),
                            mainImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                            mainImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                            mainImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
                        ])
        }

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
    private var mainView : MainView!
//    private var characterQuipLabel : UILabel?
    private let profilePicture = UIImage()// ProfilePicture
    var feed : Feed!
    
    var delegate : FeedViewInteractionDelegate?
    
    var likeButtonTapped: ((Bool) -> Void)?
    var dislikeButtonTapped: ((Bool) -> Void)?
    
    init(frame: CGRect, feed: Feed) {
        super.init(frame: frame)
        setup(feed: feed)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(feed: feed)
        layout()
    }
    
    func setup(feed : Feed) {
        
        backgroundColor = .green
        
        mainView = MainView(feed: feed)
        mainView.backgroundColor = .cyan
        self.addSubview(mainView)


        
        //  let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //  view.addGestureRecognizer(tap)
    }
    
    func layout(){
        
        let margins = self.layoutMarginsGuide
        let profilePic = UIImage(named: "fieri.jpeg")
        
        mainView.contentMode = .scaleAspectFill
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: margins.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        

        let pic = UIImageView()
        pic.layer.cornerRadius = 20
        pic.layer.masksToBounds = true
        pic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pic.layer.borderWidth = 2
        pic.backgroundColor = .white
        pic.contentMode = .scaleAspectFill
        pic.image = profilePic
        
        self.addSubview(pic)
        bringSubviewToFront(pic)
        
        pic.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pic.topAnchor.constraint(equalTo: margins.topAnchor),
            pic.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pic.heightAnchor.constraint(equalToConstant: 60),
            pic.widthAnchor.constraint(equalToConstant: 60)
        ])
        
//        if feed.text == nil{
//            characterQuipLabel!.isHidden = true
//        }
//        else{
//           backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
//
//            characterQuipLabel = UILabel(frame: self.frame)
//            characterQuipLabel!.text = feed.text
//            // self.contentOverlayView?.addSubview(Label)
//            addSubview(characterQuipLabel!)
//            characterQuipLabel!.textAlignment = .center
//            characterQuipLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
//            characterQuipLabel!.lineBreakMode = .byWordWrapping
//            characterQuipLabel!.numberOfLines = 4
//            characterQuipLabel!.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
//            characterQuipLabel!.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
//            bringSubviewToFront(characterQuipLabel!)
//
//        }
    }

}
