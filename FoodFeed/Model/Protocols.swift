//
//  Protocols.swift
//  FoodFeed
//
//  Created by Kate Roberts on 27/09/2020.
//  Copyright © 2020 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit

typealias IndexedFeed = (feed: Feed, index: Int)

protocol  FeedPagePresenterProtocol: class {
    func viewDidLoad()
    func fetchNextFeed() -> IndexedFeed?
    func fetchPreviousFeed() -> IndexedFeed?
    func updateFeedIndex(fromIndex index: Int)
    func updateFeed( index: Int, increasing: Bool) -> [Feed]
}


protocol FeedPageView: class{
    func presentInitialFeed(_ feed: Feed)
}

protocol StoryboardScene: class {
    static var sceneStoryboard: UIStoryboard { get }
    static var sceneIdentifier: String { get }
}

extension StoryboardScene {
    static var sceneIdentifier: String {
        return String(describing: self)
    }
}

extension StoryboardScene where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = Self.sceneStoryboard
        let viewController = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier)
        guard let conformingViewController = viewController as? Self else {
            fatalError("View Controller Is Not Of Type or Class '\(self)'.")
        }
        return conformingViewController
    }
}
