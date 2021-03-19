//
//  userProfileCard.swift
//  FoodFeed
//
//  Created by Kate Roberts on 18/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit
import SoftUIView

//struct userProfile


class UserProfileCard: UIView{
    
    var layoutUnit = 100.0
    var width = 100.0
    
    init(frame: CGRect, user: botUser?) {
        super.init(frame: frame)
        
        layoutUnit = Double((frame.height)/3)
        width = Double(frame.width)
        backgroundColor = .mainBackground
        setup(user: user)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // setup()
    }
    
    func setup(user: botUser?){
        
        
        let softUIView = SoftUIView(frame: .init(x: 0 , y: 0, width: width, height: 3*layoutUnit))
        addSubview(softUIView)
        
        
        
    }
    
}
