//
//  chatBubbleView.swift
//  FoodFeed
//
//  Created by Kate Roberts on 19/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit
import SoftUIView

class chatBubbleView: UIView {
    
   // var height = 100.0
    //var width = 100.0
    
    var bigText = "Tips for trying new foods?"
    let label = UILabel()
    
    var mainViewController: profileCardViewController?
   
    init(frame: CGRect, user: User?) {
        super.init(frame: frame)
        
      //  layoutUnit = (frame.height)/3
     //   width = Double(frame.width)
        backgroundColor = .mainBackground
        setup(user: user, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // setup()
    }
    
    
    func setup(user: User?, frame: CGRect){
        
        let softUIView = SoftUIView(frame: .init(x: 0 , y: 0, width: frame.width, height: frame.height ))
        addSubview(softUIView)
        
        softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        
       
        
       
        label.textAlignment = .center
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]

        let bigTextStyled = NSAttributedString(string: bigText, attributes: attrs)
        label.attributedText = bigTextStyled
        addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: softUIView.topAnchor),
            label.heightAnchor.constraint(equalToConstant: frame.height),
            label.leadingAnchor.constraint(equalTo: softUIView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -frame.width/2)
        ])
//
        
        let profilePicture = UIImageView()
        profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
        addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6 ),
            profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6),
            profilePicture.topAnchor.constraint(equalTo: softUIView.topAnchor, constant: 10),
            profilePicture.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -10)
        ])
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = frame.width/12
        profilePicture.clipsToBounds = true
    }
    
    @objc func cardTapped(){
        //mainViewController?.dismiss(animated: true, completion: nil)
        print("card Tapped")
    }
}
    

