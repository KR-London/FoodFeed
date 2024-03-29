//
//  chatBubbleView.swift
//  FoodFeed

import UIKit
import SoftUIView

class userAnswerView: UIView {

    var bigText = "Q: Tips for trying new foods?"
    var dimensionMultiplier = 0.2 as CGFloat
    
    init(frame: CGRect, user: User?) {
        super.init(frame: frame)
        
        backgroundColor = .mainBackground
        setup(user: user, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // setup()
    }
    
    func setup(user: User?, frame: CGRect){
        let humanPicDimensionUnit = frame.width*dimensionMultiplier
        
        let softUIView = SoftUIView(frame: .init(x: 0 , y: frame.height/4, width: frame.width - humanPicDimensionUnit , height: frame.height/2))
        addSubview(softUIView)
        
        softUIView.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
        softUIView.isSelected = true
        softUIView.isUserInteractionEnabled = false
        
        
        let label = UILabel()
        label.textAlignment = .center
        
        let softUIImageView = SoftUIView(frame: .init(x: frame.width - humanPicDimensionUnit , y: frame.height/2 - humanPicDimensionUnit/2, width: humanPicDimensionUnit, height: humanPicDimensionUnit))
        softUIImageView.cornerRadius = 10
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
        profilePicture.layer.cornerRadius = 10
        profilePicture.clipsToBounds = true
    }
    
    @objc func cardTapped(){
        //mainViewController?.dismiss(animated: true, completion: nil)
    }
}
    
