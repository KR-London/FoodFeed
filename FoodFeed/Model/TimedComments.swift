//
//  CommentController.swift
//  FoodFeed
//


import Foundation
import UIKit
//import Speech

struct User{
    let name: String
    let profilePic: UIImage?
    let personalQualities : [ String]?
    
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
            humanAvatar.imageView.image = human.profilePic
            humanAvatar.reloadInputViews()
            
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if let data = human.profilePic?.jpegData(compressionQuality: 1){
                let url = documents.appendingPathComponent("userSetProfilePic.jpeg")
                do {
                    try data.write(to: url)
                    // Store URL in User Defaults
                    UserDefaults.standard.set(url, forKey: "userSetPic")
                }
                catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            }
            
            UserDefaults.standard.set(human.name, forKey: "userName")
            UserDefaults.standard.set(human.personalQualities?[0], forKey: "userPersonality0")
            UserDefaults.standard.set(human.personalQualities?[1], forKey: "userPersonality1")
            UserDefaults.standard.set(human.personalQualities?[2], forKey: "userPersonality2")
     
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
    
//    let synthesizer = AVSpeechSynthesizer()
//    var utterance = AVSpeechUtterance()
    
    var currentCaption = ""

    init(){
        start()
    }
    
    func start()
    {
        stop()
        var i = 0
//        utterance = AVSpeechUtterance(string: String(currentCaption.dropFirst().dropFirst()))
//        let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
//            utterance.voice =  language.first!!
//        
//        if  #available(iOS 13.0, *){
//            synthesizer.speak(utterance)
//        }
//        
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true){ [weak self] tim in
            if self?.storedComments.count ?? 0  % 5 == 0  {
                if self?.currentCaption.isEmpty ?? false {
                    print("")
                }
                else{
                    let newComment = Comment(user: botUser.guy, comment: self?.guyComments.randomElement() ?? "", liked: false)
                    //let newComment = Comment(avatar: botUser.guy.profilePic, comment: String(i), liked: false)
                    self?.storedComments.append(newComment )
                    
//                    let say =  newComment.comment
//
//                    self.utterance = AVSpeechUtterance(string: say)
//                    utterance.voice =  AVSpeechSynthesisVoice(language: "en-AU")
//                    if  #available(iOS 13.0, *){
//                    synthesizer.speak(utterance)
//                    }
                }

            }
            else {
                let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!

                let newComment = Comment(user: bot, comment: botAnswers[String(self?.currentCaption.dropFirst().dropFirst() ?? "default answer")]?.randomElement()! ?? "", liked: false)

                self?.storedComments.append(newComment )

//                let say =  newComment.comment
//
//                utterance = AVSpeechUtterance(string: say)
//                utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
//                utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
//
//                switch bot.name{
//                    case botUser.alexis.name:
//                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                        utterance.pitchMultiplier = Float(1)
//                        utterance.rate = Float(0.5)
//                    case botUser.emery.name:
//                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                        utterance.pitchMultiplier = Float(1.1)
//                        utterance.rate = Float(0.4)
//                    case botUser.fred.name:
//                        utterance.voice = AVSpeechSynthesisVoice(language: "en-IE")
//                        utterance.pitchMultiplier = Float(1.4)
//                        utterance.rate = Float(0.6)
//                    case botUser.tony.name: utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
//                        utterance.pitchMultiplier = Float(1.5)
//                        utterance.rate = Float(0.7)
//                    default: utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
//                }
//                if  #available(iOS 13.0, *){
//                    synthesizer.speak(utterance)
//                }
            }
            i += 1
        }
        
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
        respondToUser(userComment: userComment)
    }
    
    func respondToUser(userComment: String){
        var i = 0
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true){ [weak self] tim in
            let bot = [botUser.alexis, botUser.emery, botUser.fred, botUser.tony].randomElement()!
            let newComment = Comment(user: bot, comment: botAnswersToHuman(userComment: userComment, key: self?.currentCaption ?? "default value 2"), liked: false)

            self?.storedComments.append(newComment)
            i += 1
            
//            let say =  newComment.comment
//
//            utterance = AVSpeechUtterance(string: say)
//            utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
//            utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
//
//            switch bot.name{
//                case botUser.alexis.name:
//                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                    utterance.pitchMultiplier = Float(1)
//                    utterance.rate = Float(0.5)
//                case botUser.emery.name:
//                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                    utterance.pitchMultiplier = Float(1.1)
//                    utterance.rate = Float(0.4)
//                case botUser.fred.name:
//                    utterance.voice = AVSpeechSynthesisVoice(language: "en-IE")
//                    utterance.pitchMultiplier = Float(1.4)
//                    utterance.rate = Float(0.6)
//                case botUser.tony.name: utterance.voice = AVSpeechSynthesisVoice(language: "en-IN")
//                    utterance.pitchMultiplier = Float(1.5)
//                    utterance.rate = Float(0.7)
//                default: utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
//            }
//            if  #available(iOS 13.0, *){
//                synthesizer.speak(utterance)
//            }
        }
    }
    
    var delegate: CommentProviderDelegate?
    var didUpdateComments: (([Comment]) -> Void)?

    func comments(for id: Int) -> [Comment] {
        return storedComments
    }
}
