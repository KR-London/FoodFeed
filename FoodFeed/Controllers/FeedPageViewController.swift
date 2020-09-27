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
    func presentInitialFeed(_ feed: Feed) {
        let viewController = FeedViewController.instantiate(feed: feed, andIndex: 0, isPlaying: true) as! FeedViewController
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    fileprivate var presenter: FeedPagePresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        presenter = FeedPagePresenter(view: self)
        presenter.viewDidLoad()
    }

}

extension FeedPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // what is the presenter
        guard let indexedFeed = presenter.fetchPreviousFeed() else {
            return nil
        }
        
        /// return a feed screen which realisies the information in the next item in the feed.
        return FeedViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let indexedFeed = presenter.fetchNextFeed() else {
            return nil
        }
        return FeedViewController.instantiate(feed: indexedFeed.feed, andIndex: indexedFeed.index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if
            let viewController = pageViewController.viewControllers?.first as? FeedViewController,
            let previousViewController = previousViewControllers.first as? FeedViewController
        {
           // previousViewController.pause()
            //viewController.play()
            presenter.updateFeedIndex(fromIndex: viewController.index)
            if previousViewController.index < viewController.index{
                presenter.updateFeed( index:  viewController.index as Int, increasing: true )
            }
        }
    }
}
