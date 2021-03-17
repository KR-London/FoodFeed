//
//  newCharacterViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 03/02/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import Speech

class newCharacterViewController: UIViewController {

    @IBAction func Follow(_ sender: Any) {
        UserDefaults.standard.set( ["Guy"],  forKey: "following")
        ///dismiss(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed" ) as! FeedPageViewController
            initialViewController.modalPresentationStyle = .fullScreen
        self.present(initialViewController, animated: true, completion: nil)
    }
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()

    override func viewDidLoad() {
        super.viewDidLoad()

        let say =  "Hi, I'm Guy. Follow me and help me figure out my life!"
                        
        utterance = AVSpeechUtterance(string: say)
        utterance.voice =  AVSpeechSynthesisVoice(language: "en-AU")
        synthesizer.speak(utterance)
    }

}
