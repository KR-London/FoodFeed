//
//  CommentController.swift
//  FoodFeed
//


import Foundation
import UIKit
import Speech

struct User{
    var name: String
    var profilePic: UIImage?
    var personalQualities : [ String]?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name 
    }
    
    static func ~=(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
    
}

//TO DO: update this
struct botUser{
    static let fred = User(name: "Fred", profilePic: UIImage(named:"bot1.jpeg"), personalQualities: nil)
    static let tony = User(name: "Tony", profilePic: UIImage(named:"bot2.jpeg"), personalQualities: nil)
    static let emery = User(name: "Emery", profilePic: UIImage(named:"bot3.jpeg"), personalQualities: nil)
    static let alexis = User(name: "You", profilePic: UIImage(named:"bot4.jpeg"), personalQualities: nil)
    static let guy = User(name: "You", profilePic: UIImage(named:"guy_profile_pic.jpeg"), personalQualities: nil)
    static var human = User(name: "Buddy", profilePic: UIImage(named:"U.jpeg"), personalQualities: nil){
     didSet{
         
         guard let url = UserDefaults.standard.object(forKey: "userSetPic") as? String else { return }
         guard let image = UIImage(contentsOfFile: url) else { return }
        
         human.profilePic = image
         
       //  if let name = UserDefaults.standard.object(forKey: "userSetPic") as? String
  }
    }
}

struct Comment{
    var user : User?
    var comment: String
    var liked: Bool?
    var avatar : UIImage?{
        return user?.profilePic
    }
}

protocol CommentProviderDelegate {
    func didUpdate(comments: [Comment])
}

protocol CommentProvider {
    func comments(for id: Int) -> [Comment]
    var delegate: CommentProviderDelegate? { get set }
    var didUpdateComments: (([Comment]) -> Void)? { get set }
}


// MARK: Implementation of CommentProvider
class TimedComments: CommentProvider {
    var timer : Timer?
    private var storedComments = [ Comment(user: botUser.fred, comment: "hellp", liked: false)]
    {
        didSet {
            delegate?.didUpdate(comments: storedComments)
            didUpdateComments?(storedComments)
        }
    }
    
    var ladyBookComments = ["Large portions", "Pressure", "People watching", "Music", "Noise", "Food touching", "Hidden stuff in my food", "Nagging", "Smells", "Different plates"]
    var guyComments = ["Oh yes?", "More ideas?", "Ha ha!", "I feel understood!", "That drives me mad too!"]

    var currentCaption = ""
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    

    init(){
        start()
    }
    
    func start()
    {

        utterance = AVSpeechUtterance(string: String(currentCaption.dropFirst().dropFirst()))
        let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
        utterance.voice =  language.first!!
        
        stop()
        var i = 0

        
        if  #available(iOS 13.0, *){
            synthesizer.speak(utterance)
        }

      
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){ [weak self] tim in
            if self?.storedComments.count ?? 0  % 5 == 0  {
                if self?.currentCaption.isEmpty ?? false {
                    print("")
                }
                else{
                    let newComment = Comment(user: botUser.guy, comment: self?.guyComments.randomElement() ?? "", liked: false)
                    //let newComment = Comment(avatar: botUser.guy.profilePic, comment: String(i), liked: false)
                    print(newComment.comment)
                    self?.storedComments.append(newComment )
                    
                    let say =  newComment.comment

//                    self!.utterance = AVSpeechUtterance(string: say)
//                    self!.utterance.voice =  AVSpeechSynthesisVoice(language: "en-AU")
//                    if  #available(iOS 13.0, *){
//                        self!.synthesizer.speak( self!.utterance)
//                    }
                }

            }
            else {
                let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!

                let newComment = Comment(user: bot, comment: botAnswers[String(self?.currentCaption.dropFirst().dropFirst() ?? "default answer")]?.randomElement()! ?? "", liked: false)
                print(newComment.comment)
                self?.storedComments.append(newComment )

                let say =  newComment.comment

//                self!.utterance = AVSpeechUtterance(string: say)
//                self!.utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
//                self!.utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
//
//                switch bot.name{
//                    case botUser.alexis.name:
//                        self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                        self!.utterance.pitchMultiplier = Float(1)
//                        self!.utterance.rate = Float(0.5)
//                    case botUser.emery.name:
//                        self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                        self!.utterance.pitchMultiplier = Float(1.1)
//                        self!.utterance.rate = Float(0.4)
//                    case botUser.fred.name:
//                        self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-IE")
//                        self!.utterance.pitchMultiplier = Float(1.4)
//                        self!.utterance.rate = Float(0.6)
//                    case botUser.tony.name:
//                        self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
//                        self!.utterance.pitchMultiplier = Float(1.5)
//                        self!.utterance.rate = Float(0.7)
//                    default:  self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
//                }
//                if  #available(iOS 13.0, *){
//                    self!.synthesizer.speak( self!.utterance)
//                }
            }
            i += 1
        }
        
        timer?.fire()
        
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
    }
    
    func stop(){
        self.timer?.invalidate()
      
    }
    
    deinit{
        self.timer?.invalidate()
        print("I'm in deinit")
    }
    
    func userComment(userComment: String){
        let newComment = Comment(user: botUser.human, comment: userComment, liked: false)
        self.storedComments.append(newComment)
        timer?.invalidate()
        var formattedComment = userComment.lowercased().replacingOccurrences(of: "my ", with: "their ").replacingOccurrences(of: "me ", with: "them ").replacingOccurrences(of: "i ", with: "you ")
        respondToUser(userComment: formattedComment)
    }
    
    func respondToUser(userComment: String){
        var i = 0
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){ [weak self] tim in
            let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!
            let newComment = Comment(user: bot, comment: botAnswersToHuman(userComment: userComment, key: self?.currentCaption ?? "default value 2"), liked: false)

            self?.storedComments.append(newComment)
            i += 1
            
            let say =  newComment.comment

            self!.utterance = AVSpeechUtterance(string: say)
            self!.utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
            self!.utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!

            switch bot.name{
                case botUser.alexis.name:
                    self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    self!.utterance.pitchMultiplier = Float(1)
                    self!.utterance.rate = Float(0.5)
                case botUser.emery.name:
                    self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    self!.utterance.pitchMultiplier = Float(1.1)
                    self!.utterance.rate = Float(0.4)
                case botUser.fred.name:
                    self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-IE")
                    self!.utterance.pitchMultiplier = Float(1.4)
                    self!.utterance.rate = Float(0.6)
                case botUser.tony.name:
                    self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
                    self!.utterance.pitchMultiplier = Float(1.5)
                    self!.utterance.rate = Float(0.7)
                default:  self!.utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
            }
            if  #available(iOS 13.0, *){
                self!.synthesizer.speak( self!.utterance)
            }
        }
    }
    
    var delegate: CommentProviderDelegate?
    var didUpdateComments: (([Comment]) -> Void)?

    func comments(for id: Int) -> [Comment] {
        return storedComments
    }
}
