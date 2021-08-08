//
//  FeedPageViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit
import CoreData
import AVFAudio


class FeedPageViewController:
        UIPageViewController,
        FeedPageView, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    var commentsDriver = TimedComments()
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    func presentInitialFeed(_ feed: Feed) {
        let viewController = FeedItemViewController.instantiate(feed: feed, andIndex: 0, isPlaying: true) as! FeedItemViewController
        
     
//
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    
        
        // DEBUG: this is a debugging toggle to stop the profile setting launching everytime I reload the data

        if UserDefaults.standard.object(forKey: "following") == nil
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "profileSetter")
            self.present(newViewController, animated: true, completion: nil)
        }
        else{
            
//            var loadingUser = User()
//            if let humanName = UserDefaults.standard.object(forKey: "userName"){
//                loadingUser.name = hu
//            }
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("userSetProfilePic.jpeg")
            
            
            if let name = UserDefaults.standard.object(forKey: "userName")
            {
                var pic = UIImage()
                
               if let data = try? Data(contentsOf: url){
                pic = UIImage(data: data)!
                }
               
                let personality0 = UserDefaults.standard.object(forKey: "userPersonality0") as? String ?? "Sweet"
                let personality1 = UserDefaults.standard.object(forKey: "userPersonality1") as? String ?? "Lovely"
                let personality2 = UserDefaults.standard.object(forKey: "userPersonality2") as? String ?? "Adorable"
                
                
                    let human = User(name: name as! String ,
                             profilePic: pic, personalQualities: [
                                personality0 ,
                                personality1,
                                personality2])
                    botUser.human = human
            }
        }
    }
    
    fileprivate var presenter: FeedPagePresenterProtocol!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(loadNext(_:) ),
                         name: .goForwardsNotification,
                         object: nil )

     
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
      //  let mock = MockFeedFetcher()
        let coreDataFetcher = CoreDataFeedFetcher(context: context)
        presenter = FeedPagePresenter(view: self, context:context, fetcher: coreDataFetcher)
        presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    @objc func loadNext(_ notification: NSNotification){
        //var nextFeed = Feed(id: 1, state: .text(bigText: "I moved!", caption: nil, hashtag: nil, votea: nil, voteb: nil))
        
        let nextFeed =  presenter.fetchNextFeed()!
        
        let newVC = FeedItemViewController.instantiate(feed: nextFeed.feed, andIndex: nextFeed.index.advanced(by: 1))
        presenter.updateFeedIndex(fromIndex: nextFeed.index.advanced(by: 1))
        setViewControllers([newVC], direction: .forward, animated: true, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexedFeed = presenter.fetchPreviousFeed() else {
            return nil
        }
        /// return a feed screen which realisies the information in the next item in the feed.
        return FeedItemViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let indexedFeed = presenter.fetchNextFeed() else {
            return nil
        }
        
        return FeedItemViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if
            let viewController = pageViewController.viewControllers?.first as? FeedItemViewController,
            let previousViewController = previousViewControllers.first as? FeedItemViewController
        {
            previousViewController.pause()
            //viewController.play()
            commentsDriver.stop()

            
            if viewController.feedView.interactionView.descriptiveLabel.isHidden == false{
                viewController.commentsDriver = commentsDriver
                viewController.triggerCommentsView()
            }
            
            let say = viewController.voiceOver().0
            
            utterance = AVSpeechUtterance(string: say)

            utterance = voice(who: viewController.voiceOver().1, saying: utterance)
            
            synthesizer.speak(utterance)
            
            presenter.updateFeedIndex(fromIndex: viewController.index)
           
        }
    }
}
