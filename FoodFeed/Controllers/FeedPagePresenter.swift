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
    fileprivate var currentFeedIndex =  -1 
    
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
      //  print("feed = ")
      //  print(feeds)
        let initialFeed = Feed(id: -1, state: .text(bigText: "<<<<<<<<\n Swipe! \n <<<<<< ", caption: nil, hashtag: nil, votea: nil, voteb: nil) )
        view.presentInitialFeed(initialFeed)
    }
    //"<<<<<<<<<< \n <<<<<<<<<< \n  <<<<<<<<<< \n Swipe! \n <<<<<<<<<<\n <<<<<<<<<<\n <<<<<<<<<< "
    
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
        let max = feeds.map{$0.id}.max() ?? 0
        
    
        //FIXME: this is a hack - because when i came back after christmas this was falling over becaus the index was one more than in should have. i think the extra 'tick' comes from the onboarding - so i need to look at how it's counting. For now, just put in a floor value
    
        
        guard index >= min && index <= max else {
            return nil
        }
        
        // return (feed: feeds[index], index: index)
        //FIXME: This falls over if there is a missing record - can we handle this nicer?
        print("index is \(index)")
       
        return (feeds.filter({$0.id == index    }).first ?? Feed(id: index, state: .text(bigText: "Come back again tomorrow!", caption: nil, hashtag: nil, votea: nil, voteb: nil)) , index  )
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
