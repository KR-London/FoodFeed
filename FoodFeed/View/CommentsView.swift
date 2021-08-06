//
//  CommentsView.swift
//  FoodFeed
//

import UIKit

extension UITableView {

    func setUpCommentsView(margins: UILayoutGuide){

       translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),

            widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.7)
        ])
        
        layer.cornerRadius = 20.0
    }

}
