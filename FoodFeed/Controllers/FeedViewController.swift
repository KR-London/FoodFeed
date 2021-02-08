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
    var feedView = PostView()
    
    
    fileprivate var isPlaying: Bool!
    
    let reasons = ["Not for me", "Wrong", "Upsetting", "Too loud", "Seems rude", "Boring", "Pushy"]
    var reason = String()
    
    var following = false
    
    let defaults = UserDefaults.standard

    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController{
        let viewController = FeedItemViewController.instantiate ( )
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        return viewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "following") == nil
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "hello")
                        self.present(newViewController, animated: true, completion: nil)
            }
    }
    

    override func viewDidLoad() {
        feedView = PostView(frame: self.view.frame, feed: feed)
        feedView.delegate = self
      
        view = feedView
      
        
        ///FIXME: Put back - but not when I;m voting 
//        if feed.id != 0 && feed.id != -1 {
//                setUpCommentsView()
//        }
        
    }
    
    func pause(){
        feedView.pause()
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
