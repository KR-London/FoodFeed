//
//  userProfileCard.swift
//  FoodFeed


import Foundation
import UIKit
import SoftUIView

class UserProfileCard: UIView{
    
    var layoutUnit = CGFloat(100)
    var width = 100.0

    var mainViewController: UIViewController?
    
    init(frame: CGRect, user: User?) {
        super.init(frame: frame)
        
        layoutUnit = (frame.height)/3
        width = Double(frame.width)
        backgroundColor = .mainBackground
        setup(user: user)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // setup()
    }
    
    func setup(user: User?){
        
        let softUIView = SoftUIView(frame: .init(x: 0 , y: 0, width: width, height: Double(3*layoutUnit) ))
        addSubview(softUIView)
        
        softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)

        let titleAttrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                          NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 36)!,
                          NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        
        let name = NSAttributedString(string: user?.name ?? "User Name", attributes: titleAttrs)
       
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.attributedText = name
        addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: softUIView.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 0.6*layoutUnit),
            nameLabel.leadingAnchor.constraint(equalTo: softUIView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor)
        ])

        let profilePicture = UIImageView()
        profilePicture.image = user?.profilePic ?? UIImage(named: "three.jpeg")
        addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePicture.heightAnchor.constraint(equalToConstant: layoutUnit ),
            profilePicture.widthAnchor.constraint(equalToConstant: layoutUnit),
            profilePicture.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            profilePicture.centerXAnchor.constraint(equalTo: softUIView.centerXAnchor)
        ])
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = layoutUnit/2
        profilePicture.clipsToBounds = true
        
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.textTint,
                     NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
                     NSAttributedString.Key.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
        ]
        let personality = NSAttributedString(string: (user?.personalQualities!.reduce(""){ $0 + " " + $1}) ?? "Three descriptive personality words go here", attributes: attrs)
       
        let personalityLabel = UILabel()
        personalityLabel.numberOfLines = 0
        personalityLabel.textAlignment = .center
        personalityLabel.attributedText = personality
        addSubview(personalityLabel)
        
        personalityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            personalityLabel.bottomAnchor.constraint(equalTo: softUIView.bottomAnchor, constant: -10),
            personalityLabel.heightAnchor.constraint(equalToConstant: layoutUnit),
            personalityLabel.leadingAnchor.constraint(equalTo: softUIView.leadingAnchor, constant: 20),
            personalityLabel.trailingAnchor.constraint(equalTo: softUIView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func cardTapped(){
        mainViewController?.dismiss(animated: true, completion: nil)       
    }
}
