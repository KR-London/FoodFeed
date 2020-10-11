//
//  CommentController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 11/10/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit

typealias Comment = String

protocol CommentProviderDelegate {
    func didUpdate(comments: [Comment])
}
protocol CommentProvider
{
    func comments(for id: Int) -> [Comment]
    var delegate: CommentProviderDelegate? { get set }
    var didUpdateComments: (([Comment]) -> Void)? { get set }
}


// MARK: Implementation of CommentProvider
class TimedComments: CommentProvider {
    private var timer = Timer()
    private var storedComments = ["Comment 1", "Comment 2"]
    {
        didSet {
            delegate?.didUpdate(comments: storedComments)
            didUpdateComments?(storedComments)
        }
    }
    
    
    init()
    {
        var i = 3
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ tim in
            self.storedComments.append("Comment \(i)")
            i += 1
        }
        
    }
    
    
    var delegate: CommentProviderDelegate?
    var didUpdateComments: (([Comment]) -> Void)?
    func comments(for id: Int) -> [Comment] {
        return storedComments
    }
}
