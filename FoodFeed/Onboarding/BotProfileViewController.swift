//
//  BotProfileViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 18/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import SoftUIView
import Speech

class BotProfileViewController: UIViewController {
    
    
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()


        override func viewDidLoad() {
            super.viewDidLoad()
            layoutSubviews()

            let say =  "Hi, I'm Guy. Follow me and help me figure out my life!"
                            
            utterance = AVSpeechUtterance(string: say)
            utterance.voice =  AVSpeechSynthesisVoice(language: "en-AU")
           // synthesizer.speak(utterance)
        }

        func layoutSubviews(){
            
            let layoutUnit = 0.9*(self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/6

            ///Title
            let pageTitle = UILabel()
            let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                              NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 36)!,
                              NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
            
            let string = NSAttributedString(string: "NEW FRIEND?", attributes: titleAttrs)
            pageTitle.attributedText = string
            view.addSubview(pageTitle)
            
            pageTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pageTitle.centerYAnchor.constraint(equalTo: view.topAnchor , constant: layoutUnit),
                pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])

            
            let attrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                         NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                         NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
            ]
            
            
            /// Little pop-out summary card
            
            let guy = User(name: "Guy", profilePic: botUser.guy.profilePic , personalQualities: ["Fun" , "Chatty", "Open"])
            
            let card = UserProfileCard( frame: CGRect(x: 20, y: 1.5*layoutUnit, width: view.frame.width - 40, height: 3*layoutUnit) , user: guy)
            view.addSubview(card)
    //
    //        okLabel.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            okLabel.topAnchor.constraint(equalTo: softUIViewButton.topAnchor),
    //            okLabel.bottomAnchor.constraint(equalTo: softUIViewButton.bottomAnchor),
    //            okLabel.leadingAnchor.constraint(equalTo: softUIViewButton.leadingAnchor),
    //            okLabel.trailingAnchor.constraint(equalTo: softUIViewButton.trailingAnchor)
    //        ])
            
            
            // Segue button
            
            let softUIViewButton = SoftUIView(frame: .init(x: 20, y: 5.2*layoutUnit, width: self.view.frame.width - 40 , height: 0.7*layoutUnit))
            view.addSubview(softUIViewButton)
            let okLabel = UILabel()
            //okLabel.text = "OK"
            okLabel.attributedText = NSAttributedString(string: "OK", attributes: titleAttrs)
            // softUIViewButton.setContentView(okLabel)
            
            softUIViewButton.addTarget(self, action: #selector(segueToMain), for: .touchUpInside)
            
            okLabel.textAlignment = .center
            view.addSubview(okLabel)
            
            okLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                okLabel.topAnchor.constraint(equalTo: softUIViewButton.topAnchor),
                okLabel.bottomAnchor.constraint(equalTo: softUIViewButton.bottomAnchor),
                okLabel.leadingAnchor.constraint(equalTo: softUIViewButton.leadingAnchor),
                okLabel.trailingAnchor.constraint(equalTo: softUIViewButton.trailingAnchor)
            ])
            
     
            
        }
        
        @objc func segueToMain(){
            UserDefaults.standard.set( ["Guy"],  forKey: "following")
  
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed" ) as! FeedPageViewController
                initialViewController.modalPresentationStyle = .fullScreen
            self.present(initialViewController, animated: true, completion: nil)
        }
    }
