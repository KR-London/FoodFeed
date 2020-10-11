//
//  FeedFetchService.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation

protocol FeedFetchDelegate: class {
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds feeds: [Feed], withError error: Error?)
}

protocol FeedFetchProtocol: class {
    var delegate: FeedFetchDelegate? { get set }
    func fetchFeeds()
}


class FeedFetcher: FeedFetchProtocol {
    
    fileprivate let networking: ConnectionProtocol.Type
    var delegate: FeedFetchDelegate?
    
    init(networking: ConnectionProtocol.Type = Connection.self) {
        self.networking = networking
    }
    
    func fetchFeeds() {
      //  var feeds = [Feed(id: 1, text: "One")]
        
     //   self.delegate?.feedFetchService(self, didFetchFeeds: feeds, withError: nil)
    }
    
    //fileprivate func fetchFeedSuccess(withData data: Data) {
    fileprivate func fetchFeedSuccess(withData data: Data) {
      //  var feeds = [Feed(id: 1, text: nil )]
    
       // self.delegate?.feedFetchService(self, didFetchFeeds: feeds, withError: nil)
    
    }
}

class MockFeedFetcher: FeedFetchProtocol{
    var delegate: FeedFetchDelegate?
    
//    let mockFeed = [Feed(id: 0, text: "Swipe!", image:nil), Feed(id: 1, text: nil, image: "one.jpeg"), Feed(id: 2, text: "Stay curious!" , image: nil), Feed(id: 3, text: nil, image: "three.jpeg" ), Feed(id: 4, text: "I might try this and think it's not bad.", image: nil), Feed(id: 5, text: nil, image: "two.jpeg"), Feed(id: 6, text: "Party today!", image: nil )]
    
    let mockFeed = [Feed(id: 1, text: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"), Feed(id: 2, text: nil, image: "one.jpeg", gifName: nil, originalFilename: "original2"), Feed(id: 3, text: nil, image: "two.jpeg", gifName: nil, originalFilename: "original2")]
    
    func fetchFeeds() {
        delegate?.feedFetchService(self, didFetchFeeds: mockFeed, withError: nil)
    }
    
    
}
