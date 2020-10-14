//
//  FeedPagePresenter.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation

class FeedPagePresenter: FeedPagePresenterProtocol{
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds feeds: [Feed], withError error: Error?) {
      //  view.stopLoading()
        
        if let error = error {
      //      view.showMessage(error.localizedDescription)
            return
        }
       // let initialFeed = Feed(id: 1, text: nil)
       // view.presentInitialFeed(initialFeed)
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
    
    func viewDidLoad() {
        fetcher.delegate = self
       // configureAudioSession()
        
        
        // FIXME: Not supposed to need this - mock feed fetcher is supposed to take care of this.
        feeds = [Feed(id: 0, text: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"),
                 Feed(id: 1, text: "My best friends birthday next week!", image: nil, gifName: nil, originalFilename: "original2"),
                 Feed(id: 2, text: nil, image: nil, gifName: "giphy30.gif", originalFilename: "original3")]
        //feeds = fetcher.returnFeed()
        
        fetchFeeds()
        let initialFeed = Feed(id: 0, text:  "Swipe!", image: nil, gifName: nil, originalFilename: "originalStarter")
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
        let max = feeds.map{$0.id}.max() ?? 15
        
        guard index >= min && index <= max else {
            return nil
        }
        
        // return (feed: feeds[index], index: index)
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
