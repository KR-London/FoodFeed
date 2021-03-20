//
//  softCommentTableViewCell.swift
//  FoodFeed
//
//  Created by Kate Roberts on 19/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class softCommentTableViewCell: UITableViewCell {
    var botAnswerView = userAnswerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), user: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .blue
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func commonInit(){
       // botAnswerView = userAnswerView(frame: self.frame, user: botUser.emery)
      //  self.addSubview(botAnswerView)
        
    }
    
    func updateText(){
        botAnswerView.bigText = "I updated text"
    }

}
