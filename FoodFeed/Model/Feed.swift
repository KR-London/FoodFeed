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
        
        case text(bigText: String, caption: String?, hashtag: String?, votea: String?, voteb: String?, who: Personage)
        case image(imageName: String, caption: String?, hashtag: String?, who: Personage)
        case gif(gifName: String, caption: String?, hashtag: String?, who: Personage)
        case video(videoName: String, hashtag: String?, who: Personage)
        
        case poll(caption: String, votea: String, voteb: String, votec: String, hashtag: String?, who: Personage)
        
        case question(caption: String, hashtag: String?, who: Personage)
        
        case photoPrompt(caption: String, hashtag: String?, who: Personage)
        
        init(from decoder: Decoder) throws {
            self = .text(bigText: "Keep Going!", caption: nil, hashtag: nil, votea: "I will!", voteb: "I'm digging in!", who: .Avery )
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
