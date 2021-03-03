//
//  CommentsView.swift
//  FoodFeed
//
//  Created by Kate Roberts on 11/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import UIKit

extension UITableView {

    func setUpCommentsView(margins: UILayoutGuide){
        backgroundColor = UIColor(white: 0.1, alpha: 0.2)
       translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),
           // bottomAnchor.constraint(equalTo: margins.bottomAnchor),
           // leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10),
            widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.7)
        ])
        
        layer.cornerRadius = 20.0
    }

}
