//
//  CommentController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 11/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit
import Speech

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
    var timer : Timer?
    private var storedComments = [ Comment(avatar: botUser.fred.profilePic, comment: "hellp", liked: false)]
    {
        didSet {
            delegate?.didUpdate(comments: storedComments)
            didUpdateComments?(storedComments)
        }
    }
    
    var ladyBookComments = ["Large portions", "Pressure", "People watching", "Music", "Noise", "Food touching", "Hidden stuff in my food", "Nagging", "Smells", "Different plates"]
    var guyComments = ["Oh yes?", "More ideas?", "Ha ha!", "I feel understood!", "That drives me mad too!"]
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()

    
    init()
    {
        var i = 2
        
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true){ [self] tim in
            if storedComments.count % 5 == 0{
                let newComment = Comment(avatar: botUser.guy.profilePic, comment: guyComments.randomElement()!, liked: false)
                self.storedComments.append(newComment )
                
               let say =  newComment.comment

                   utterance = AVSpeechUtterance(string: say)
                   utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
                   utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
                    let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
                   utterance.voice =  language.first!!
                   synthesizer.speak(utterance)

            }
            else {
                let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!
                let newComment = Comment(avatar: bot.profilePic, comment: ladyBookComments.randomElement()!, liked: false)
                self.storedComments.append(newComment )
                
                let say =  newComment.comment
                
                utterance = AVSpeechUtterance(string: say)
                utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
                utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
                let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
                utterance.voice =  language.first!!
                synthesizer.speak(utterance)
            }
            i += 1
            
           
        }
        
    }
    
    func stop(){
        self.timer?.invalidate()
    }
    
//    deinit{
//        self.timer.invalidate()
//    }
    
    func userComment(userComment: String){
        print(userComment)
        let newComment = Comment(avatar: botUser.human.profilePic, comment: userComment, liked: false)
        self.storedComments.append(newComment)
        timer?.invalidate()
        respondToUser(userComment: userComment)
    }
    
    func respondToUser(userComment: String){
        var i = 0
        var responseComments = ["I hate \(userComment) too!", "Urggh" , "I agree", "Ha ha"]
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true){ tim in
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
