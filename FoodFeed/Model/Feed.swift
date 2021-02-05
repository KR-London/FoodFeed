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
    
    enum State : Decodable {
        
        case text(bigText: String)
        case image(imageName: String)
        case gif(gifName: String)
        case video(videoName: String)
        case poll(caption: String, votea: String, voteb: String)
        
        init(from decoder: Decoder) throws {
            self = .text(bigText: "Keep Going!")
        }
    }
    
    struct Author { // fix up model maybe, fine for now
        let ID: UUID
        let avatar: URL
        let username: String
    }
    
    let state: State
}


struct coreDataFeed: Decodable{
    var id: Int
    
    // Content types
    let bigtext: String?
    let image: String?
    let gifName: String?
    

}
