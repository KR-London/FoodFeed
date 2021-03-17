//
//  commentTableViewCell.swift
//  FoodFeed
//
//  Created by Kate Roberts on 04/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit


class commentTableViewCell: UITableViewCell {

    @IBOutlet var speechBubble: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var reaction: UIButton!
    @IBOutlet var avatarView: AvatarView!
    @IBAction func likeClicked(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            if sender.imageView?.image == UIImage(systemName: "suit.heart"){
                sender.setImage( UIImage(systemName: "suit.heart.fill"),for: UIControl.State.normal)
            }
            else{
                sender.setImage( UIImage(systemName: "suit.heart"),for: UIControl.State.normal)
            }
        } else {
            if sender.imageView?.image == UIImage(named: "341-3417063_herz-clipart.png"){
                sender.setImage( UIImage(named: "filled_favourite-512.png"),for: UIControl.State.normal)
            }
            else{
                sender.setImage( UIImage(named: "341-3417063_herz-clipart.png"),for: UIControl.State.normal)
            }
        }
    }
    
    @IBOutlet var contentVIew: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit(){
    //    Bundle.main.loadNibNamed("commentTableViewCell", owner: self, options: nil)
        
        if #available(iOS 13.0, *) {
           reaction.setImage( UIImage(systemName: "suit.heart"),for: UIControl.State.normal)
        } else {
             reaction.setImage( UIImage(named: "341-3417063_herz-clipart.png"),for: UIControl.State.normal)
            speechBubble.image = UIImage(named: "speechBubble.png") 
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleTopMargin]
       // bringSubviewToFront(reaction)
        //translatesAutoresizingMaskIntoConstraints = false
       // heightAnchor.constraint(equalToConstant: 250.5).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
