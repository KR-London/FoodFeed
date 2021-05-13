//
//  profileCardViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 18/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import SoftUIView

class profileCardViewController: UIViewController {
    
    var human : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .mainBackground
        layoutSubviews()
 
    }

    func layoutSubviews(){
        
        let layoutUnit = 0.9*(self.view.frame.height - (self.navigationController?.navigationBar.frame.height ?? 0))/6
       // let margins = view.layoutMarginsGuide
 
        
        ///Title
        let pageTitle = UILabel()
        let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                          NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 36)!,
                          NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let string = NSAttributedString(string: "YOU", attributes: titleAttrs)
        pageTitle.attributedText = string
        view.addSubview(pageTitle)
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageTitle.centerYAnchor.constraint(equalTo: view.topAnchor , constant: layoutUnit),
            pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        /// Little pop-out summary card
        
        let card = UserProfileCard( frame: CGRect(x: 20, y: 1.5*layoutUnit, width: view.frame.width - 40, height: 3*layoutUnit) , user: human) 
        
        card.mainViewController = self
        
        
        view.addSubview(card)
        
//        if #available(iOS 13.0, *) {
//            // use UIStackView
//        } else {
//            let hiddenButton = UIButton()
//            hiddenButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
//            hiddenButton.backgroundColor = .clear
//            hiddenButton.frame = CGRect(x: 20, y: 1.5*layoutUnit, width: view.frame.width - 40, height: 3*layoutUnit)
//            
//            view.addSubview(hiddenButton)
//        }
  
        // Segue button
        
        let softUIViewButton = SoftUIView(frame: .init(x: 20, y: 5.2*layoutUnit, width: self.view.frame.width - 40 , height: 0.7*layoutUnit))
        view.addSubview(softUIViewButton)
        let okLabel = UILabel()
        //okLabel.text = "OK"
        okLabel.attributedText = NSAttributedString(string: "OK", attributes: titleAttrs)
        // softUIViewButton.setContentView(okLabel)
        
        softUIViewButton.addTarget(self, action: #selector(segueToFriend), for: .touchUpInside)
        
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
    
 
    
    @objc func segueToFriend(){
        performSegue(withIdentifier: "friendProfile", sender: self)
    }
}
