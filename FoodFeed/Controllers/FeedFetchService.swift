//
//  FeedFetchService.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import CoreData

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
    
 let mockFeed = [Feed(id: 1, bigtext: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"), Feed(id: 2, bigtext: nil, image: "one.jpeg", gifName: nil, originalFilename: "original2"), Feed(id: 3, bigtext: nil, image: "two.jpeg", gifName: nil, originalFilename: "original2")]
    
    func fetchFeeds() {
        delegate?.feedFetchService(self, didFetchFeeds: mockFeed, withError: nil)
    }
}

class CoreDataFeedFetcher: FeedFetchProtocol{
    var delegate: FeedFetchDelegate?
    
    fileprivate let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchFeeds() {

        
        var request: NSFetchRequest<PostData> = PostData.fetchRequest()
       // NSPredicate(format: "name == %@", "Python")
        //request.propertiesToFetch = ["bigtext"]
        request.predicate = NSPredicate(format: "day == %i", 1)
        
        var newFeedArray = [ Feed(id: 0, bigtext: "Day 1", image: nil,  gifName: nil, originalFilename: "original1") ]

        do{
            let fetchedPosts = try context.fetch(request)
                //as! [coreDataFeed]
            
            fetchedPosts.forEach({
                let newFeedItem = Feed(id: Int($0.id), bigtext: $0.bigtext, image: $0.image,  gifName: $0.gif, originalFilename: "original1")
                                    print($0.bigtext)
                
                newFeedArray.append(newFeedItem)
            })
            //delegate?.feedFetchService(self, didFetchFeeds: fetchedPosts, withError: nil)
        } catch {
            fatalError("Couldn't fetch the posts \(error)")
        }
        print(newFeedArray.flatMap({$0.id}))
//        newFeedArray = [Feed(id: 1, bigtext: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"), Feed(id: 2, bigtext: nil, image: "one.jpeg", gifName: nil, originalFilename: "original2"), Feed(id: 3, bigtext: nil, image: "two.jpeg", gifName: nil, originalFilename: "original2")]
        delegate?.feedFetchService(self, didFetchFeeds: newFeedArray, withError: nil)
    }
    
    func loadPosts(){
        
    }
    
    
}
