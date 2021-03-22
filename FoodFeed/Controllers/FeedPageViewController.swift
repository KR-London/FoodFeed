//
//  FeedPageViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit


class FeedPageViewController:
        UIPageViewController,
        FeedPageView
{
    var commentsDriver = TimedComments()
    
    func presentInitialFeed(_ feed: Feed) {
        let viewController = FeedItemViewController.instantiate(feed: feed, andIndex: 0, isPlaying: true) as! FeedItemViewController
        
     
//
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "following") == nil
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "profileSetter")
            self.present(newViewController, animated: true, completion: nil)
        }
        
        //commentsDriver?.start()
        
        //        commentsDriver = TimedComments()
        //        if let caption = feedView.interactionView.caption.text
        //        {
        //            commentsDriver?.currentCaption = caption
        //        }
        //        //commentsDriver?.currentCaption = f
    }
    
    fileprivate var presenter: FeedPagePresenterProtocol!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
     
        let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
      //  let mock = MockFeedFetcher()
        let coreDataFetcher = CoreDataFeedFetcher(context: context)
        presenter = FeedPagePresenter(view: self, context:context, fetcher: coreDataFetcher)
        presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
}

extension FeedPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
            //commentsDriver.stop()
            viewController.commentsDriver = commentsDriver
           
            viewController.triggerCommentsView()
            presenter.updateFeedIndex(fromIndex: viewController.index)
            if previousViewController.index < viewController.index{
                presenter.updateFeed( index:  viewController.index as Int, increasing: true )
            }
           
        }
    }
}
