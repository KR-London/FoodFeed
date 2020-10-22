//
//  FeedViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 28/08/2020.


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
        let feedView = FeedItemView(frame: self.view.frame, feed: feed)
        feedView.delegate = self
        view = feedView
        setUpCommentsView()
    }


    // MARK: Comments Work
    // Custom layout of a UITableView; connect up to the view controller that manages the timed release of the comments; set self as delegate for the table view
    func setUpCommentsView(){


        view.addSubview(commentsView)
        commentsView.setUpCommentsView(margins: view.layoutMarginsGuide)

        commentsDriver.didUpdateComments =
        {
            comments in
            self.comments = comments
            self.commentsView.reloadData()
        }
        
        commentsView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseID)
        commentsView.delegate = self
        commentsView.dataSource = self

  }
    
    func setUpCommentsPipeline(){
        
    }
    
    // MARK: Likes & Dislikes actions
        
        // Notes a like &toggles the value in user defaults
        func likeTapped(_ sender: UIButton) {
            
        var liked = defaults.array(forKey: "Liked") as? [String]

        if #available(iOS 13.0, *) {
            if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
            {
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
        func dislikeTapped(_ sender: UIButton) {
            
            print("Dislike tapped")

            //pause()

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
     //   self.commentsView.reloadData()
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
    
}
