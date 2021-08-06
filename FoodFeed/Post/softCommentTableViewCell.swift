//
//  softCommentTableViewCell.swift
//  FoodFeed
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

    }
    
    private func commonInit(){

    }
    
    func updateText(){
        botAnswerView.bigText = "I updated text"
    }

}
