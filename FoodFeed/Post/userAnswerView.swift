//
//  chatBubbleView.swift
//  FoodFeed
//
//  Created by Kate Roberts on 19/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//
import UIKit
import SoftUIView

class userAnswerView: UIView {
    
    // var height = 100.0
    //var width = 100.0
    
    var bigText = "Q: Tips for trying new foods?"
    
    //   var postView: postView?
    
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
        
        let humanPicDimensionUnit = frame.width/5
        
        let softUIView = SoftUIView(frame: .init(x: humanPicDimensionUnit , y: frame.height/4, width: frame.width - humanPicDimensionUnit , height: frame.height/2))
        addSubview(softUIView)
        
        softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        softUIView.isSelected = true
        softUIView.isUserInteractionEnabled = false
        
        
        let label = UILabel()
        label.textAlignment = .center
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.xeniaGreen,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        
        
        let softUIImageView = SoftUIView(frame: .init(x: 0 , y: frame.height/2 - humanPicDimensionUnit/2, width: humanPicDimensionUnit, height: humanPicDimensionUnit))
        softUIImageView.cornerRadius = humanPicDimensionUnit/2
        addSubview(softUIImageView)
        
        let profilePicture = UIImageView()
        profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
        addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: humanPicDimensionUnit),
            profilePicture.widthAnchor.constraint(equalToConstant: humanPicDimensionUnit),
            profilePicture.topAnchor.constraint(equalTo: softUIImageView.topAnchor),
            profilePicture.leadingAnchor.constraint(equalTo: softUIImageView.leadingAnchor)
        ])
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = humanPicDimensionUnit/2
        profilePicture.clipsToBounds = true
    }
    
    @objc func cardTapped(){
        //mainViewController?.dismiss(animated: true, completion: nil)
        print("card Tapped")
    }
}
    
