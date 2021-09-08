//
//  FeedFetchService.swift
//  FoodFeed
//
import Foundation
import CoreData



protocol FeedFetchDelegate: AnyObject {
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds feeds: [Feed], withError error: Error?)
}

protocol FeedFetchProtocol: AnyObject {
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

        let request: NSFetchRequest<PostData> = PostData.fetchRequest()
    
        request.predicate = NSPredicate(format: "day == %i", day)
        request.returnsObjectsAsFaults = false

        let dayString = "Day " + String(day)
        var newFeedArray = [ Feed(id: 0, state: .text(bigText: dayString, caption: "", hashtag: "", votea: nil, voteb: nil, who: .Avery) )]

        do{
            let fetchedPosts = try context.fetch(request)

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
        } catch {
            fatalError("Couldn't fetch the posts \(error)")
        }
        
        // data validation
        if newFeedArray.compactMap({$0.id}).min() ?? 1  > 0 {
            print("This data will not show up at all - because the first post is numbered bigger than zero ")
        }
        delegate?.feedFetchService(self, didFetchFeeds: newFeedArray, withError: nil)
    }
    
    func loadPosts(){
        
    }
    
    
}
