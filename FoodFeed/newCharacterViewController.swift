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
        dismiss(animated: true)
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
