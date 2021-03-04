//
//  commentTableViewCell.swift
//  FoodFeed
//
//  Created by Kate Roberts on 04/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var reaction: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
