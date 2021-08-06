import Foundation
import Combine
import UIKit
import AVFAudio

enum Backend {
    struct Author: Identifiable {
        var id: Int
        var avatar: URL
        var username: String
    }

    struct Media {
        enum Kind {
            case image
            case gif
        }
        var kind: Kind
        var url: URL
    }
    
    struct Tag: Identifiable {
        var id: String {
            return "#" + name
        }
        var name: String
    }
    
    struct Post: Identifiable {
        var id: Int
        var authorID: Author
        var caption: String
        var media: Media
        var tags: [Tag]
    }
    
    struct Poll: Identifiable {
        enum Option {
            case First
            case Second
        }
        var id: Int
        var question: String
        var firstOptionVotes: Int
        var secondOptionVotes: Int
        var selection: Option?
    }
}

struct Post {
    typealias Author = Backend.Author
    typealias HashTag = String
    typealias Caption = String
    typealias Poll = Backend.Poll

    enum Media {
        case image(URL)
        case gif(URL)
        case video(URL)
    }
    
    enum Interaction {
        case poll(Poll)
        case photo
        case comment
    }
    
    struct Post {
        var author: Author
        var hashTag: HashTag
        var media: Media
        var interaction: Interaction
        var caption: Caption
        var comments: [Comment]
    }
}

enum FeedPost {
    typealias Author = Backend.Author
    typealias HashTag = String
    typealias Caption = String
    typealias Poll = Backend.Poll

    enum Media {
        case image(URL)
        case gif(URL)
        case video(URL)
    }
    
    enum Interaction {
        case poll(Poll)
        case photo
        case comment
    }
    
    struct Post {
        var author: Author
        var hashTag: HashTag
        var media: Media
        var interaction: Interaction
        var caption: Caption
        var comments: [Comment]
    }
}

protocol BackendService {
    // MARK: Getting Feed
    func getPosts(day: Int) -> [Backend.Post]
    func getPost(id: Backend.Post.ID) -> Backend.Post
    
    // MARK: Interactions
    func comment(content: String, postID: Backend.Post.ID) // "text box interaction"
    func respondWithPhoto(photo: Data) // "take photo prompt"
    func vote(pollID: Backend.Poll.ID, selectedOption: Backend.Poll.Option) // "poll interaction"
}

class LocalBackendService: BackendService {
    var posts: [Int: [Backend.Post]] = [
        0: [], // fill with posts
        1: [], // fill with posts
    ]
        
    func getPosts(day: Int) -> [Backend.Post] {
        return posts[day]!
    }
    
    func getPost(id: Backend.Post.ID) -> Backend.Post {
        fatalError("not implemented")
    }
    
    func comment(content: String, postID: Backend.Post.ID) {
        fatalError("not implemented")
    }
    
    func respondWithPhoto(photo: Data) {
        fatalError("not implemented")
    }
    
    func vote(pollID: Backend.Poll.ID, selectedOption: Backend.Poll.Option) {
    }
    
    func updatePostsBasedOnSelection() {
        // update posts based on selectedThings
    }
}

struct Preferences {
    let favColor: String
    let favAnimal: String
}

func postsFor(preferences: Preferences) -> [Backend.Post] {

    fatalError()
}

enum Personage: String{
    case Guy
    case DG
    case Avery
    case Brock
    case Unknown
}
func profilePicture(who: Personage) -> UIImage{
    print(who)
    switch who {
    case .Guy:
        return UIImage(named: "guy_profile_pic.jpeg")!
    case .DG:
        return UIImage(named: "bot1.jpeg")!
    case .Avery:
        return UIImage(named: "bot2.jpeg")!
    default:
        return UIImage(named: "bot3.jpeg")!
    }
}

func profilePicture(who: String) -> UIImage{
    print(who)
    switch who {
    case "Guy":
        return UIImage(named: "guy_profile_pic.jpeg")!
    case "DG":
        return UIImage(named: "bot1.jpeg")!
    case "Avery":
        return UIImage(named: "bot2.jpeg")!
    default:
        return UIImage(named: "bot3.jpeg")!
    }
}

func whoIsIt(name: String?) -> Personage{
    print(name)
    switch name {
    case "Guy":
        return .Guy
    case "DG":
        return .DG
  case "Brock":
        return .Brock
    case "Avery":
        return .Avery
    default:
        return .Unknown
    }

}


func voice(who: Personage, saying: AVSpeechUtterance) -> AVSpeechUtterance{

    var utterance = saying
    
    switch who{
        case .Guy:
            utterance.pitchMultiplier = Float(0.9)
            utterance.rate = Float(0.5)
            let language = AVSpeechSynthesisVoice(language: "en-US")
            utterance.voice =  language
            return utterance
        case .DG:
            utterance.pitchMultiplier = Float(0.7)
            utterance.rate = Float(0.5)
            let language = AVSpeechSynthesisVoice(language: "en-US")
            utterance.voice =  language
            return utterance
        case .Avery:
            utterance.pitchMultiplier = Float(1.1)
            utterance.rate = Float(0.6)
            let language = AVSpeechSynthesisVoice(language: "en-IE")
            utterance.voice =  language
            return utterance
        case .Brock:
            utterance.pitchMultiplier = Float(0.7)
            utterance.rate = Float(0.5)
            let language = AVSpeechSynthesisVoice(language: "en-AU")
            utterance.voice =  language
            return utterance
        default:
            print("Unknown voice")
    } 
    return saying
}
