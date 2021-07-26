//
//  FeedFetchService.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import CoreData

let day = 3

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
    
 //let mockFeed = [Feed(id: 1, bigtext: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"), Feed(id: 2, bigtext: nil, image: "one.jpeg", gifName: nil, originalFilename: "original2"), Feed(id: 3, bigtext: nil, image: "two.jpeg", gifName: nil, originalFilename: "original2")]
    
    func fetchFeeds() {
  //      delegate?.feedFetchService(self, didFetchFeeds: mockFeed, withError: nil)
    }
}

class CoreDataFeedFetcher: FeedFetchProtocol{
    var delegate: FeedFetchDelegate?
    
    fileprivate let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchFeeds() {

        /// call on coreData to get info on what i should show
        
        
        let request: NSFetchRequest<PostData> = PostData.fetchRequest()
       // NSPredicate(format: "name == %@", "Python")
        //request.propertiesToFetch = ["bigtext"]
      // let day = ((UserDefaults.standard.object(forKey: "loginRecord") as? [ Date ] )?.count ?? 1 )
       
        request.predicate = NSPredicate(format: "day == %i", day)
        request.returnsObjectsAsFaults = false
        //var newFeedArray = [ Feed(id: 0, bigtext: "Day 1", image: nil,  gifName: nil, originalFilename: "original1") ]
        let dayString = "Day " + String(day)
        var newFeedArray = [ Feed(id: 0, state: .text(bigText: dayString, caption: "", hashtag: "", votea: nil, voteb: nil, who: .Avery) )]
       // var newFeedArray = [ Feed(id: 0, state: .text(bigText: dayString, caption: "", hashtag: "") )]

        do{
            let fetchedPosts = try context.fetch(request)
                //as! [coreDataFeed]
            newFeedArray = newFeedArray.filter{$0.id != 0 }
            fetchedPosts.forEach({
                switch $0.type {
                    case "Text":
                        let newFeedItem = Feed(id: Int($0.id), state: .text(bigText: $0.bigtext ?? "Error - no text stored in text post", caption: $0.caption ?? "", hashtag: $0.hashtag, votea: $0.votea, voteb: $0.voteb, who: whoIsIt(name: $0.user) ))
                        newFeedArray.append(newFeedItem)
                    case "Image":
                        if let imageName = $0.image{
                            let newFeedItem = Feed(id: Int($0.id) , state: .image(imageName: imageName, caption: $0.caption ?? "" , hashtag: $0.hashtag, who: whoIsIt(name: $0.user) ) )
                            newFeedArray.append(newFeedItem)
                        } else {
                            print("Inconsistently formatted image record \($0)")
                        }
                    case "Gif":
                        if let gifName = $0.gif{
                            let newFeedItem = Feed(id: Int($0.id), state: .gif(gifName: gifName, caption: $0.caption ?? "" , hashtag: $0.hashtag, who:  whoIsIt(name: $0.user) ))
                            newFeedArray.append(newFeedItem)
                        } else {
                            print("Inconsistently formatted gif record \($0)")
                        }
                    case "PhotoPrompt":
                        let newFeedItem = Feed(id: Int($0.id), state: .text(bigText: "PhotoPrompt", caption: $0.caption ?? "" , hashtag: $0.hashtag, votea: $0.votea, voteb: $0.voteb, who: whoIsIt(name: $0.user) ) )
                        newFeedArray.append(newFeedItem)
                    case "Video":
                        if let videoName = $0.video{
                            let newFeedItem = Feed(id: Int($0.id), state: .video(videoName: videoName, hashtag: $0.hashtag, who: whoIsIt(name: $0.user) ) )
                            newFeedArray.append(newFeedItem)
                        }
                    case "Vote": // should i allow for missing captions...?
                        let caption = $0.caption ?? $0.bigtext ?? "Vote!!!"
                        
                        if let votea = $0.votea{
                            if let voteb = $0.voteb{
                                if let votec = $0.votec{
                                    let newFeedItem = Feed(id: Int($0.id), state: .poll(caption: caption, votea: votea, voteb: voteb, votec: votec, hashtag: ($0.hashtag ?? "Getting to know") + " " + botUser.human.name, who: whoIsIt(name: $0.user) ) )
                                    newFeedArray.append(newFeedItem)
                                }
                            }
                        }
                    case "Question":
                        if let caption = $0.caption{
                            let newFeedItem = Feed(id: Int($0.id), state: .question(caption: caption, hashtag: $0.hashtag, who: whoIsIt(name: $0.user)) )
                            newFeedArray = newFeedArray.filter{ Int($0.id) != Int(newFeedItem.id) }
                            newFeedArray.append(newFeedItem)
                        }

                default:  let newFeedItem = Feed(id: Int($0.id), state: .text(bigText: "I couldn't find actionable content here", caption: $0.caption ?? "" , hashtag: $0.hashtag, votea: $0.votea, voteb: $0.voteb, who: whoIsIt(name: $0.user)) )
                        newFeedArray.append(newFeedItem)
                }

            })
            //delegate?.feedFetchService(self, didFetchFeeds: fetchedPosts, withError: nil)
            
        } catch {
            fatalError("Couldn't fetch the posts \(error)")
        }
        
        
        print(newFeedArray.flatMap({$0.id}))
        
        // data validation
        if newFeedArray.flatMap({$0.id}).min() ?? 1  > 0 {
            print("This data will not show up at all - because the first post is numbered bigger than zero ")
        }
        
        for x in newFeedArray.flatMap({$0.id}){
            if x < newFeedArray.flatMap({$0.id}).max() ?? 0{
                if newFeedArray.flatMap({$0.id}).filter({$0 == x + 1}) == nil {
                    print("Data after position \(x) will not show up, because id indeces are not sequential")
                }
            }
        }
        
//        newFeedArray = [Feed(id: 1, bigtext: "Swipe!", image:nil, gifName: "giphy-13.gif", originalFilename: "original1"), Feed(id: 2, bigtext: nil, image: "one.jpeg", gifName: nil, originalFilename: "original2"), Feed(id: 3, bigtext: nil, image: "two.jpeg", gifName: nil, originalFilename: "original2")]
       // newFeedArray = Array(newFeedArray.dropFirst())
        
        delegate?.feedFetchService(self, didFetchFeeds: newFeedArray, withError: nil)
    }
    
    func loadPosts(){
        
    }
    
    
}
