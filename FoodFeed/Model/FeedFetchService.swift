//
//  FeedFetchService.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation



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

