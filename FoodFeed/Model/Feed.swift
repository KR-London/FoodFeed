//
//  Feed.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation

struct Feed: Decodable{
    var id: Int
    
    // Content types
    let text: String?
    let image: String?
    let gifName: String?
    
    let originalFilename: String
   // var liked = false
    
    func toAnyObject() -> Any {
        return [
            "name": originalFilename,
        //    "liked": liked,
        ]
    }
    
}
