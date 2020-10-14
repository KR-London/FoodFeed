//
//  FeedViewLayout.swift
//  FoodFeed
//
//  Created by Kate Roberts on 12/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit

class FeedViewLayout: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }

    private func setUpView(){
        backgroundColor = .red
    }
}
