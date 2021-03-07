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
    static let fred = User(name: "Fred", profilePic: UIImage(named:"bot1.jpeg"))
    static let tony = User(name: "Tony", profilePic: UIImage(named:"bot2.jpeg"))
    static let emery = User(name: "Emery", profilePic: UIImage(named:"bot3.jpeg"))
    static let alexis = User(name: "You", profilePic: UIImage(named:"bot4.jpeg"))
    static let guy = User(name: "You", profilePic: UIImage(named:"guy_profile_pic.jpeg"))
    static let human = User(name: "You", profilePic: UIImage(named:"U.jpeg"))
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
    
    var ladyBookComments = ["Large portions", "Pressure", "People watching", "Music", "Noise", "Food touching", "Hidden stuff in my food", "Nagging", "Smells", "Different plates"]
    var guyComments = ["Oh yes?", "More ideas?", "Ha ha!", "I feel understood!", "That drives me mad too!"]
    
    init()
    {
        var i = 2
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ [self] tim in
            if storedComments.count % 5 == 0{
                let newComment = Comment(avatar: botUser.guy.profilePic, comment: guyComments.randomElement()!, liked: false)
                self.storedComments.append(newComment )
                
            }
            else {
                let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!
                let newComment = Comment(avatar: bot.profilePic, comment: ladyBookComments.randomElement()!, liked: false)
                self.storedComments.append(newComment )
            }
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
        var responseComments = ["I hate \(userComment) too!", "Urggh" , "I agree", "Ha ha"]
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ tim in
            let newComment = Comment(avatar: botUser.fred.profilePic, comment: responseComments.randomElement()!, liked: false)
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
