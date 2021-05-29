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
    var label = UILabel()
    
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
    
    func updateCaption(){
        print("Update caption")
    }
    
    
    func setup(user: User?, frame: CGRect){
        
        if user ?? botUser.fred == botUser.human {
           var softUIView = SoftUIView(frame: .init(x: -frame.width/24 , y: 0, width: (5/6)*frame.width, height: frame.height ))
            softUIView.backgroundColor = .purple
            addSubview(softUIView)
            
            softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
            
            label.textAlignment = .center
            addSubview(label)
            label.textColor = .textTint
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: softUIView.topAnchor),
                label.heightAnchor.constraint(equalToConstant: frame.height),
                label.leadingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -5)
            ])
            
            let profilePicture = UIImageView()
            profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
            addSubview(profilePicture)
            profilePicture.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6  ),
                profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6  ),
                profilePicture.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor),
                profilePicture.leadingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -frame.width/24)
            ])
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.layer.cornerRadius = 10
            profilePicture.clipsToBounds = true
            
        }
        else{
            let softUIView = SoftUIView(frame: .init(x: frame.width/6 , y: 0, width: (5/6)*frame.width, height: frame.height ))
            addSubview(softUIView)
            
            softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)

            label.textAlignment = .center
            addSubview(label)
            label.textColor = .textTint
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: softUIView.topAnchor),
                label.heightAnchor.constraint(equalToConstant: frame.height),
                label.leadingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -5)
            ])
        
            let profilePicture = UIImageView()
            profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
            addSubview(profilePicture)
            profilePicture.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6  ),
                profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6  ),
                profilePicture.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor),
                profilePicture.trailingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: -frame.width/24)
            ])
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.layer.cornerRadius = 10
            profilePicture.clipsToBounds = true
        }
    }
    
    @objc func cardTapped(){
        print("card Tapped")
    }
}

