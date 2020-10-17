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

class FeedItemViewController: UIViewController,StoryboardScene, UIPickerViewDelegate {

    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!

    static let reuseID = "CELL"
    
    let commentsView = UITableView()
    var commentsDriver = TimedComments()
    var comments: [Comment] = []
    var commentButton = UIButton()
    
    fileprivate var isPlaying: Bool!
    
    let reasons = ["Not for me", "Wrong", "Upsetting", "Too loud", "Seems rude", "Boring", "Pushy"]
    var reason = String()
    
    let defaults = UserDefaults.standard

    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController{
        let viewController = FeedItemViewController.instantiate ( )
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }

    override func viewDidLoad() {
        
        let feedView = FeedItemView()
        // layout etx.
        
        feedView.dislikeButtonTapped {
            // update userdefaults / whatever
        }
        
        
        super.viewDidLoad()
        
        commentsView.setUpCommentsView()
        self.view.feedViewLayout(feed: feed, profilePic: UIImage(named: "fieri.jpeg")!, sender: self )

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        setUpCommentsView()
    }
    
    // likeTapped
    // 1. change appearance of button i.e to a "tapped" state
    // 2. update userdefaults to remember what use liked
    
    // dislikeTapped
    // upate appearance
    // bring up action menu to say why
    // update userdefaults
    
    // play/pause
    //
    
    func setUpCommentsView(){
        
        let margins = view.layoutMarginsGuide
        
        commentsDriver.didUpdateComments =
            {
                comments in
                self.comments = comments
                self.commentsView.reloadData()
            }
        commentsView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseID)
        commentsView.delegate = self
        commentsView.dataSource = self
        
        view.addSubview(commentsView)
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentsView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),
            commentsView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            commentsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10),
            commentsView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.6)
        ])

        view.bringSubviewToFront(commentsView)
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

extension FeedItemViewController: FeedViewInteractionDelegate{
    var delegate: CommentProviderDelegate? {
        get {
            self
        }
        set {
        }
    }
    
    func dontLikeThis(sender: UIView) {
        print("I don't like this")
    }
    
   func likeTapped(_ sender: UIButton) {
        print("Back in VC")
    }
    
}
