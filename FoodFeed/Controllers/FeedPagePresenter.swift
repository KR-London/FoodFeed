//
//  FeedPagePresenter.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import CoreData

class FeedPagePresenter: FeedPagePresenterProtocol{
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds fetchedFeeds: [Feed], withError error: Error?) {
        feeds = fetchedFeeds
        
        if let error = error {
                print(error.localizedDescription)
            return
        }

    }

    fileprivate unowned var view: FeedPageView
    
    fileprivate var fetcher: FeedFetchProtocol
    fileprivate var feeds: [Feed] = []
    fileprivate var currentFeedIndex = 0
    
    init(view: FeedPageView, fetcher: FeedFetchProtocol = FeedFetcher()) {
        self.view = view
        //self.fetcher = fetcher
        self.fetcher =  MockFeedFetcher()
    }
    
    init(view: FeedPageView, context: NSManagedObjectContext, fetcher: FeedFetchProtocol = FeedFetcher()) {
        self.view = view
        self.fetcher =  CoreDataFeedFetcher(context:context)
    }
    
    
    func viewDidLoad() {
        fetcher.delegate = self
       // configureAudioSession()

        fetchFeeds()
        let initialFeed = Feed(id: 0, state: .text(bigText: "Swipe!") )
        view.presentInitialFeed(initialFeed)
    }
    
    fileprivate func fetchFeeds() {
       // view.startLoading()
        fetcher.fetchFeeds()
    }
    
    func fetchNextFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex + 1)
    }
    
    func fetchPreviousFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex - 1)
    }
    
    fileprivate func getFeed(atIndex index: Int) -> IndexedFeed? {
        
        let min = feeds.map{$0.id}.min() ?? 0
        
        //FIXME: This was setting at 59?!?! That's weird
        //let max = feeds.map{$0.id}.max() ?? 15
        let max = 20
        
        guard index >= min && index <= max else {
            return nil
        }
        
        // return (feed: feeds[index], index: index)
        //FIXME: This falls over if there is a missing record - can we handle this nicer?
        print("index is \(index)")
        return (feeds.filter({$0.id == index}).first! , index)
    }
    
    func updateFeedIndex(fromIndex index: Int) {
        currentFeedIndex = index
    }
}

extension FeedPagePresenter: FeedFetchDelegate{
    
    // This makes the feed sequence repeat
    func updateFeed( index : Int, increasing : Bool) -> [Feed]{
        
        var itemToAddToEndOfLoop = feeds[index]
        itemToAddToEndOfLoop.id = feeds.count - 1
        feeds.append(itemToAddToEndOfLoop)
        
        return feeds
    }
}
