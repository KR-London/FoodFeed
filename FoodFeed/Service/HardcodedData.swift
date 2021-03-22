//
//  HardcodedData.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import Foundation


/// this reallly should be done in a more dynamic way!

let botAnswers = [
    "What makes a meal stressful for you?" : ["Large portions", "Pressure",
                                              "People watching", "Music",
                                              "Noise",
                                              "Food touching", "Hidden stuff in my food",
                                              "Nagging",
                                              "Smells",
                                              "Different plates", "What do you think, \(botUser.human.name)?"],
    "Tips to explore new foods?":  ["Napkin to spit in!",
        "Ask for samples in the store!",
        "I watch food TV shows to find out about food.", "Ketchup. Dip it in ketchup.",
        "Big drink in my hand in case I don’t like the taste",
        "Nibble with my front teeth",
        "Put it on a cracker", "I’m more open to trying new things in new places."],
    "What in the world is hummus???": ["I don’t know!",
        "Is it cheese?",
        "My mum eats it as a dip",
        "It’s kind of brown…?",
        "It’s like chickpeas mashed up?",
        "It tastes lemony.”, “It’s not bad - smooth texture",
        "It has protein in it. Protein builds muscles."],
    "How do you celebrate life's little wins?": ["Robux!",
                                                 "Big pat on the back",
                                                 "Get food I like", "Balloons!",
                                                 "Tell my mum",
                                                 "Tell my best friend",
                                                 "I don’t like rewards - they stress me", "Celebration dance", "What do you think, \(botUser.human.name)?",
                                                 "We need someone \(String(describing: botUser.human.personalQualities?.randomElement())) to help us figure this out!"],
    "How do you deal with smell?": ["Fan to blow it away from me!",
                                    "Keep your distance!",
                                    "Cover your nose", "Masks come in handy!",
                                    "Switch seats",
                                    "Check it out with a distant sniff", "Some smells "],
    "llo": ["FudFid is a game to help you know yourself better", "Make friends with some cute characters", "Swipe to get started!"]
]

func botAnswersToHuman(userComment: String, key: String) -> String{
    
    let positiveWords = ["ace", "great", "super", "really helping me out", "a good friend"]
    
//    var personalQualities = [String]
//
//    func initialiseGrammar(){
//        for i = 0 .. 2 {
//            if ["a", "e", "i", "o", "u"].contains(botUser.human.personalQualities?[i].first){
//                personalQualities.append("an \(botUser.human.personalQualities?[i])")
//            }
//            else{
//            personalQualities.append("an \(botUser.human.personalQualities?[i])")
//            }
//        }
//    }
    
    let botAnswer = [
        "What makes a meal stressful for you?" :  ["Awww - I understand, \(botUser.human.name).", "I hate \(userComment) too!",     "Urggh" ,   "I agree", "I'm not sure my family know how much \(userComment) upsets me"],
        "Tips to explore new foods?":  ["I like your thinking, \(botUser.human.name)",
                                        "I might try \(userComment) too!",
                                        "That’s actually a great idea.",
                                        "Does that help?",
                                        "Win some, lose some - it’s still progress" ,
                                        "You are \(String(describing: botUser.human.personalQualities?.randomElement())) friend \(botUser.human.name)."],
        "What in the world is hummus???": [
            "I never knew that, \(botUser.human.name)!" ,
            "Really?!?!",
            "Is that true???", "You are \(String(describing: positiveWords.randomElement()) )" ,
            "How do you celebrate life's little wins?", "I might try \(userComment) too!", "That’s actually a great idea." , "Oh - that’s nice!", "Super cool", "I bet that makes you feel good about yourself", "Party at \(botUser.human.name)'s house!"],
    "How do you deal with smell?":  ["I do \(userComment) too!", "Great thinking \(botUser.human.name)!" , "What happens when you do that?", "Does that help?"]
]
    
    return botAnswer[String(key.dropFirst().dropFirst())]?.randomElement() ?? "Good answer"
}

