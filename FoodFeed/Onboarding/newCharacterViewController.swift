//
//  newCharacterViewController.swift
//  FoodFeed
//

import UIKit
import Speech

class newCharacterViewController: UIViewController {

    @IBAction func Follow(_ sender: Any) {
        UserDefaults.standard.set( ["Guy"],  forKey: "following")
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
       
        if  #available(iOS 13.0, *){
        synthesizer.speak(utterance)
        }
    }

}
