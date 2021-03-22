//
//  testViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 22/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                           NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                                           NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
                             ]
        
        let bigTextStyled = NSAttributedString(string: "Hello World", attributes: attrs)
        label.attributedText = bigTextStyled
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
