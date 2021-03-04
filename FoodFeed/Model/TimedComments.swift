//
//  CommentController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 11/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit

///typealias Comment = String

struct User{
    let name: String
    let profilePic: UIImage?
}


//TO DO: update this
struct botUser{
    static let fred = User(name: "Fred", profilePic: UIImage(named:"one.jpeg"))
    static let tony = User(name: "Tony", profilePic: UIImage(named:"one.jpeg"))
    static let emery = User(name: "Emery", profilePic: UIImage(named:"one.jpeg"))
    static let human = User(name: "You", profilePic: UIImage(named:"one.jpeg"))
}
//enum botUser{
//    case fred = User(name: "Fred", profilePic: UIImage(named:"one.jpeg"))
//    case  tony = User(name: "Tony", profilePic: UIImage(named:"one.jpeg"))
//    case  emery = User(name: "Emery", profilePic: UIImage(named:"one.jpeg"))
//    case  human = User(name: "You", profilePic: UIImage(named:"one.jpeg"))
//}

struct Comment{
    var avatar: UIImage?
    var comment: String
    var liked: Bool?
}

protocol CommentProviderDelegate {
    func didUpdate(comments: [Comment])
}

protocol CommentProvider
{
    func comments(for id: Int) -> [Comment]
    var delegate: CommentProviderDelegate? { get set }
    var didUpdateComments: (([Comment]) -> Void)? { get set }
}


// MARK: Implementation of CommentProvider
class TimedComments: CommentProvider {
    private var timer = Timer()
    private var storedComments = [ Comment(avatar: botUser.fred.profilePic, comment: "hellp", liked: false)]
    {
        didSet {
            delegate?.didUpdate(comments: storedComments)
            didUpdateComments?(storedComments)
        }
    }
    
    var ladyBookComments = ["Take advantage of free samples", "Become a relaxation expert", "Get enough sleep, nourishment, and exercise.", "Connect with others.", "Connect with nature.", "Pay attention to the good things."]
    
    init()
    {
        var i = 2
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ [self] tim in
            let newComment = Comment(avatar: botUser.emery.profilePic, comment: ladyBookComments.randomElement()!, liked: false)
            self.storedComments.append(newComment )
            i += 1
        }
        
    }
    
    func userComment(userComment: String){
        print(userComment)
        let newComment = Comment(avatar: botUser.human.profilePic, comment: userComment, liked: false)
        self.storedComments.append(newComment)
        timer.invalidate()
        respondToUser(userComment: userComment)
    }
    
    func respondToUser(userComment: String){
        var i = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ tim in
            let newComment = Comment(avatar: botUser.fred.profilePic, comment: "I like \(userComment) too!", liked: false)
            self.storedComments.append(newComment)
            i += 1
        }
    }
    
    
    var delegate: CommentProviderDelegate?
    var didUpdateComments: (([Comment]) -> Void)?
    
    
    
    
    func comments(for id: Int) -> [Comment] {
        return storedComments
    }
}
