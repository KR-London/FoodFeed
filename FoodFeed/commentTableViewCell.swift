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
    @IBOutlet var avatarView: AvatarView!
    
    @IBOutlet var contentVIew: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit(){
    //    Bundle.main.loadNibNamed("commentTableViewCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleTopMargin]
        //translatesAutoresizingMaskIntoConstraints = false
       // heightAnchor.constraint(equalToConstant: 250.5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
