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
    
    
    
    
    let profilePicture = UIImageView()
    
    var mainViewController: profileCardViewController?
   
    init(frame: CGRect, user: User?) {
        super.init(frame: frame)
        
      //  layoutUnit = (frame.height)/3
     //   width = Double(frame.width)
        //backgroundColor = .mainBackground
        backgroundColor = .clear
        setup(user: user, frame: frame)
    }
    
//    init() {
//        super.init(frame: CGRect)
//
//        //  layoutUnit = (frame.height)/3
//        //   width = Double(frame.width)
//        backgroundColor = .mainBackground
//        setup(user: user, frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // setup()
    }
    
    func updateCaption(){
        print("Update caption")
    }
    
    
    func reloadData(comment : Comment){
//        profilePicture.clear()
//        profilePicture.image = comment.user!.profilePic ?? imageWith(name: comment.user?.name)
//
//        if profilePicture.image?.size.width == 0 {
//            profilePicture.image = imageWith(name: comment.user?.name)
//        }
//
//        self.reloadInputViews()
        
        
        setup(user: comment.user, frame: self.frame)
        label.text = comment.comment
        profilePicture.image = comment.user!.profilePic ?? imageWith(name: comment.user?.name)
        
       if profilePicture.image?.size.width == 0 {
            profilePicture.image = imageWith(name: comment.user?.name)
        }
        
        self.reloadInputViews()
    
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = [ UIColor.option1, UIColor.option2, UIColor.option3 ].randomElement()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                }
            }
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func setup(user: User?, frame: CGRect){
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        
        var softUIView = SoftUIView(frame: .init(x: frame.width/6 , y: 0, width: (5/6)*frame.width, height: frame.height ))
        
       
       
        guard let realUser = user
        else{
                            
                            addSubview(softUIView)
           // softUIView.
                            softUIView.isHidden = true
            
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
            
//                          profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
//
//                            addSubview(profilePicture)
//                            profilePicture.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6  ),
//                                profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6  ),
//                                profilePicture.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor),
//                                profilePicture.trailingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: -frame.width/24)
//                            ])
//                            profilePicture.contentMode = .scaleAspectFill
//                            profilePicture.layer.cornerRadius = 10
//                            profilePicture.clipsToBounds = true
                            //profilePicture.isHidden = true
            return
        
        }
        
        profilePicture.isHidden = false
        
switch realUser {
            case botUser.human :
                softUIView = SoftUIView(frame: .init(x: -frame.width/24 , y: 0, width: (5/6)*frame.width, height: frame.height ))
                softUIView.backgroundColor = .textTint
                addSubview(softUIView)
                
                softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
                softUIView.mainColor = UIColor.textTint.cgColor
                
                label.textAlignment = .center
                addSubview(label)
                label.backgroundColor = .clear
                label.textColor = .white
                label.clipsToBounds = true
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
                
                
//                profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
//                addSubview(profilePicture)
//                profilePicture.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6  ),
//                    profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6  ),
//                    profilePicture.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor),
//                    profilePicture.leadingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: frame.width/24)
//                ])
//                profilePicture.contentMode = .scaleAspectFill
//                profilePicture.layer.cornerRadius = 10
//                profilePicture.clipsToBounds = true
//                profilePicture.isHidden = false
//            case nil:

                
            default:
//                let softUIView = SoftUIView(frame: .init(x: frame.width/6 , y: 0, width: (5/6)*frame.width, height: frame.height ))
                addSubview(softUIView)
                
                softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
                label.textAlignment = .center
                addSubview(label)
                label.backgroundColor = .clear
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
                
//                profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
//                addSubview(profilePicture)
//                profilePicture.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    profilePicture.heightAnchor.constraint(equalToConstant: frame.width/6  ),
//                    profilePicture.widthAnchor.constraint(equalToConstant: frame.width/6  ),
//                    profilePicture.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor),
//                    profilePicture.trailingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: -frame.width/24)
//                ])
//                profilePicture.contentMode = .scaleAspectFill
//                profilePicture.layer.cornerRadius = 10
//                profilePicture.clipsToBounds = true
//                profilePicture.isHidden = false
        }
        
    }
    
    @objc func cardTapped(){
        print("card Tapped")
    }
}

