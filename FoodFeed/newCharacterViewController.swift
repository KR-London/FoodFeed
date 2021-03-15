//
//  newCharacterViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 03/02/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class newCharacterViewController: UIViewController {

    @IBAction func Follow(_ sender: Any) {
        UserDefaults.standard.set( ["Guy"],  forKey: "following")
        ///dismiss(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
      
        
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Feed" ) as! FeedPageViewController
            initialViewController.modalPresentationStyle = .fullScreen
            self.present(initialViewController, animated: true, completion: nil)
        //dismiss(animated: true)
        //self.window?.rootViewController = initialViewController
        
                    //   let nextViewController = storyboard.instantiateViewController(withIdentifier: "newDataInputViewController" )
                    //self.window?.rootViewController!.push(nextViewController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
