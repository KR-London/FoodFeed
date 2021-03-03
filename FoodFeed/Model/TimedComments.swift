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
    private var storedComments = ["Interesting!"]
    {
        didSet {
            delegate?.didUpdate(comments: storedComments)
            didUpdateComments?(storedComments)
        }
    }
    
    
    init()
    {
        var i = 2
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true){ tim in
            self.storedComments.append("Comment \(i)")
            i += 1
        }
        
    }
    
    func userComment(userComment: String){
        print(userComment)
        self.storedComments.append(userComment)
        timer.invalidate()
        respondToUser(userComment: userComment)
    }
    
    func respondToUser(userComment: String){
        var i = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true){ tim in
            self.storedComments.append("I like \(userComment) too!")
            i += 1
        }
    }
    
    
    var delegate: CommentProviderDelegate?
    var didUpdateComments: (([Comment]) -> Void)?
    
    
    
    
    func comments(for id: Int) -> [Comment] {
        return storedComments
    }
}
