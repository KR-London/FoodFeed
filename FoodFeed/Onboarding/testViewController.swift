//
//  testViewController.swift
//  FoodFeed
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString ]
        
        let bigTextStyled = NSAttributedString(string: "Hello World", attributes: attrs)
        label.attributedText = bigTextStyled
    }
}
