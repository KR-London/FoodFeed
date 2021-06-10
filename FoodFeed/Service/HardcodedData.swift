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
                                                 "We need someone smart to help us figure this out!"],
    "How do you deal with smell?": ["Fan to blow it away from me!",
                                    "Keep your distance!",
                                    "Cover your nose", "Masks come in handy!",
                                    "Switch seats",
                                    "Check it out with a distant sniff", "Some smells "],
    "The big question: what is the best breakfast ever?" : ["Cereal", "Eggs on toast", "No really into breakfast", "Last night's pizza", "Ramen noodles. Best breakfast lunch and dinner"],
    "I'm so stressed right now. How can I calm down before I do something I regret ...?" : ["Breathe in through your nose and out through your mouth", "Count to ten backwards", "I like to shut my eyes and imagine I'm on the beach"],
    "Aaaah - I want to say 'no' - but how can I do that without upsetting Frank?" : ["Just be honest", "NO. That works", "Nopedy nopedy nopedy no bleurgh bleurgh bleugh", "Tell him the real reason", "Change your name and leave the country", "Get your more polite friend to talk to him for you"],
    "My head is full of worry about how I will eat on this trip. What makes a meal fun for you?": ["Nothing is ever perfect", "I only like being on my own in my room in front of the TV", "I like to choose myself what goes on my plate.", "I like it when everyone is relaxed and chatty", "Eating with my friends is more fun than eating with my family because we chat.", "Takeaway pizza in the park", "A bag of M&Ms playing a board game", "Buffets are nice. I try a little bit, then come back for more if it's good"],
    "I feel like everyone else is doing better than me. Have you people ever felt like you don’t really fit in?": ["Oh - all the time.", "I look confident on the outside - but on the inside I worry", "My words get muddled. I worry people will laugh at me, so I just don't talk", "I don't fit in. I am one of a kind?", "Who wants to fit in when you can stand out?"],
       "Who makes you feel more confident?" : ["My Mom", "My cat. I always feel better after I talk to my cat", "My Dad really believes in me", "My big sister explains things to me. I always feel more confident if I know what to expect.", "Teachers are good at that."]
    //,
 //   "llo": ["FudFid is a game to help you know yourself better", "Make friends with some cute characters", "Swipe to get started!"]
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
    
    //\(String(describing: botUser.human.personalQualities!.randomElement()!).lowercased())
    
    let botAnswer = [
        "What makes a meal stressful for you?" :  ["Awww - I understand, \(botUser.human.name).",
                                                   "I hate \(userComment) too!",
                                                   "Urggh" ,
                                                   "I agree",
                                                   "I'm not sure my family know how much \(userComment) upsets me"],
        "Tips to explore new foods?":  ["I like your thinking, \(botUser.human.name).",
                                        "I might try \(userComment) too!",
                                        "That’s actually a great idea.",
                                        "Does that help?",
                                        "Win some, lose some - it’s still progress" ,
                                        "You are a great friend \(botUser.human.name)."],
        "What in the world is hummus???": ["I never knew that, \(botUser.human.name)!" ,
                                        "Really?!?!",
                                        "Is that true???",
                                        "You are brilliant" ],
        "How do you celebrate life's little wins?": ["I might try \(userComment) too!",
                                                    "That’s actually a great idea." ,
                                                    "Oh - that’s nice!",
                                                    "Super cool",
                                                    "I bet that makes you feel good about yourself",
                                                    "Party at \(botUser.human.name)'s house!"],
    "How do you deal with smell?":  ["I do \(userComment) too!",
                                     "Great thinking \(botUser.human.name)!" ,
                                     "What happens when you do that?",
                                     "Does that help?"],
        "What is the best breakfast ever?" : ["\(userComment) on toast?", "I know a great cafe that serves only \(userComment)", "Have you tried sprinkling cheese on top of \(userComment)? Everything tastes better with cheese.", "@Guy - did you see what \(botUser.human.name) said?", "That's dope"],
        "[I'm so stressed right now. How can I calm down before I do something I regret ...?" : ["@Guy - do you think \(userComment) would help?", "\(botUser.human.name), you know a lot!","\(botUser.human.name), that's an interesting idea.", " Radical!"],
        "Aaaah - I want to say 'no' - but how can I do that without upsetting Frank?" : ["@Guy - have you tried \(userComment)?", "Guy - your new buddy \(botUser.human.name) is smart!", "\(userComment)?!?! Nice idea - but what if Frank still gets upset", "\(userComment) - ha! Never thought of that!", "\(userComment) [lovehearteyes]", "\(botUser.human.name), I'm glad you're here"],
        "My head is full of worry about how I will eat on this trip. What makes a meal fun for you?": [" \(userComment) sounds perfect!", "\(botUser.human.name) - you are fun!", "\(userComment)?!?! Sweet!", "\(userComment) - ha! Never thought of that!", "\(userComment) [lovehearteyes]", "@Guy - do you think the meals on the trip might be \(userComment)?"],
        "I feel like everyone else is doing better than me. Have you people ever felt like you don’t really fit in?":["Thank you \(botUser.human.name)", "@Guy - you see - even \(botUser.human.name) - and they look so confident", "\(userComment)? I understand.", "\(botUser.human.name), you are doing great."],
        "Who makes you feel more confident?": ["\(userComment) helps \(botUser.human.name) feel more confident!", "I wish \(userComment) would talk to me ... ", "\(botUser.human.name) - do you feel better after you talk to them?", "\(botUser.human.name) - you always seem so confident - I can't imagine someone like you ever feels worried!", "Would \(userComment) be able to help you, Guy?"]
]
    
    return botAnswer[String(key.dropFirst().dropFirst())]?.randomElement() ?? "Good answer"
}

