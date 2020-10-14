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
import SwiftyGif

class FeedItemViewController: UIViewController,StoryboardScene, UIPickerViewDelegate{

    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!
    var characterQuipLabel = UILabel()
    
    static let reuseID = "CELL"
    
    let commentsView = UITableView()
    
    
    
    var commentsDriver = TimedComments()
    var comments: [Comment] = []
    
    fileprivate var isPlaying: Bool!
    
    let reasons = ["Not for me", "Wrong", "Upsetting", "Too loud", "Seems rude", "Boring", "Pushy"]
    var reason = String()
    
    let defaults = UserDefaults.standard
    
    //MARK: Lazy instantiation of elements
    lazy var likeButton :        UIButton = {
        
        let button = UIButton()
        
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.titleLabel!.text = "Like"
        button.titleLabel!.text = "Dislike"
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            button.setTitle("Like", for: .normal)
        }
        button.tintColor = UIColor.green
        button.layer.cornerRadius = 50
        
        button.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
        
        return button
    }()

    lazy var dislikeButton :        UIButton = {
        
        let button = UIButton()
        
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.titleLabel!.text = "Dislike"
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "hand.raised.slash"), for: .normal)
        } else {
            button.setTitle("X", for: .normal)
        }
        button.tintColor = UIColor.green
        button.layer.cornerRadius = 50
        
        button.addTarget(self, action: #selector(dislikeTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var profilePicture : UIImageView = {
        
        let pic = UIImageView()
        
        pic.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pic.widthAnchor.constraint(equalToConstant: 40).isActive = true
        pic.layer.cornerRadius = 20
        pic.layer.masksToBounds = true
        pic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pic.layer.borderWidth = 2
        pic.backgroundColor = .white
        pic.contentMode = .scaleAspectFill
        
        return pic
    }()
    
    var commentButton = UIButton()
    
    var buttonStack : UIStackView = {
        
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.contentMode = .scaleAspectFit
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    var mainImage = UIImageView()
    
    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController{
        let viewController = FeedItemViewController.instantiate ( )
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsView.setUpCommentsView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        if let image = feed.image {
            mainImage.image = UIImage(named: image)
        }
        layoutSubviews()
        if let gifName = feed.gifName {
            do {
                let gif = try UIImage(gifName: gifName)
                mainImage = UIImageView(gifImage: gif, loopCount: -1)
                mainImage.frame = view.bounds
                view.addSubview(mainImage)
            } catch {
                print(error)
            }
        }
        
        commentsDriver.didUpdateComments =
            {
                comments in
                self.comments = comments
                self.commentsView.reloadData()
            }
        commentsView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseID)
        commentsView.delegate = self
        commentsView.dataSource = self
        
        view.bringSubviewToFront(buttonStack)
        view.bringSubviewToFront(commentsView)
        

    }
    
    func layoutSubviews(){
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(commentsView)
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentsView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),
            commentsView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            commentsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10),
            commentsView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.6)
        ])
        
        profilePicture.image = UIImage(named: ["fieri.jpeg"].randomElement()!)
        
        buttonStack.addArrangedSubview(profilePicture)
        buttonStack.addArrangedSubview(likeButton)
        buttonStack.addArrangedSubview(dislikeButton)
        
        self.view.addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
            buttonStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            buttonStack.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.1)
        ])
   
        
        self.view.addSubview(mainImage)
        mainImage.contentMode = .scaleAspectFill
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: margins.topAnchor),
            mainImage.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            mainImage.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
        if feed.text == nil{
            characterQuipLabel.isHidden = true
        }
        else{
            view.backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
            characterQuipLabel = UILabel(frame: self.view.frame)
            characterQuipLabel.text = feed.text
           // self.contentOverlayView?.addSubview(Label)
            view.addSubview(characterQuipLabel)
            characterQuipLabel.textAlignment = .center
            characterQuipLabel.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
            characterQuipLabel.lineBreakMode = .byWordWrapping
            characterQuipLabel.numberOfLines = 4
            characterQuipLabel.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
            characterQuipLabel.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
            view.bringSubviewToFront(characterQuipLabel)
        }
    }
    
    func setUpCommentsPipeline(){
        
    }
        
        // Notes a like
        // toggles the value in user defaults, and changes appearance of button to match.
        @objc func likeTapped(_ sender: UIButton) {
            var liked = defaults.array(forKey: "Liked") as? [String]
            
            if #available(iOS 13.0, *) {
                if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
                {
                    sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                    feed.liked = true
                    ///FIXME: Likes not persisiting(feed.gif as String)
                    let ref =  feed.image ?? feed.text ??  ""
                    
                    if let _ = liked {
                        liked = liked! + [ref]
                    }
                    else{
                        liked =  [ref]
                    }
                    
                    defaults.set( liked , forKey: "Liked")
                    
                }
                else
                {
                    sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                    sender.tintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                    feed.liked = false
                    
                    //FIXME: feed.gif ?? to persisist likes
                    let ref = feed.image ?? feed.text ??  ""
                    
                    if let _ = liked {
                        liked = liked!.filter{ $0 != ref}
                    }
                    defaults.set( liked , forKey: "Liked")
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
        
        
        // Notes that the user doesn't like a certain post
        // Gets some clarification why, and sends the data to Firestore
        @objc func dislikeTapped(_ sender: UIButton) {
            
            pause()
            
            let reasonPicker = UIPickerView()
            
            reasonPicker.dataSource = self
            reasonPicker.delegate = self
            
            let alert = UIAlertController(title: "Don't Want This?", message: "Can you tell me why to help me do better in future? \n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            alert.view.addSubview(reasonPicker)
            reasonPicker.frame = CGRect(x: 0, y: 40, width: 270, height: 200)
            
            let selectAction = UIAlertAction(title: "OK", style: .default, handler: saveDislike)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(selectAction.copy() as! UIAlertAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            
        }
        
        func saveDislike(_ input: UIAlertAction){
            print("ME NO LIKE")
            defaults.set( [feed.originalFilename] , forKey: "disliked")
            
            //TODO: Likes
            
            //  let dataToSave : [String: Any] = ["name": feed.originalFilename, "reason": reason]
            
            //   let docRef = userRef.document(Auth.auth().currentUser?.email ?? "Anonymous" + String(Int.random(in: 1...1000))).collection("dislikes").document(feed.originalFilename)
            
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
            
            // Create new Alert
            
            var dialogMessage = UIAlertController(title: "Thank you", message: "We have noted you don't like this, and it won't show up in future sessions. We will also personally review your feedback to try to do better for you in the future.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
    
    // Pauses video playback on tap
    //FIXME: pause gifs and voice
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        // TODO: pause gifs
        
//        didPause = !didPause
//        if didPause{
//            pause()
//        }
//        else{
//            play()
//        }
    }
    }

extension FeedItemViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return reasons.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        reason = reasons[row]
        self.view.endEditing(true)
    }
    
}

extension FeedItemViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseID, for: indexPath)
        cell.backgroundColor = UIColor.clear
        if indexPath.row < comments.count {
            cell.textLabel?.text = comments[comments.count - indexPath.row - 1]
        }
        return cell
    }
}

extension FeedItemViewController: CommentProviderDelegate{
    func didUpdate(comments: [Comment]){
        self.comments = comments
        self.commentsView.reloadData()
    }
}
