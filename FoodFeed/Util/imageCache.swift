//
//  imageCache.swift
//  FoodFeed
//
//  Created by Kate Roberts on 24/07/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import Foundation


//    // Returns the cached image if available, otherwise asynchronously loads and caches it.
//final func load(url: NSURL, item: Item, completion: @escaping (Item, UIImage?) -> Swift.Void) {
//        // Check for a cached image.
//    if let cachedImage = image(url: url) {
//        DispatchQueue.main.async {
//            completion(item, cachedImage)
//        }
//        return
//    }
//        // In case there are more than one requestor for the image, we append their completion block.
//    if loadingResponses[url] != nil {
//        loadingResponses[url]?.append(completion)
//        return
//    } else {
//        loadingResponses[url] = [completion]
//    }
//        // Go fetch the image.
//    ImageURLProtocol.urlSession().dataTask(with: url as URL) { (data, response, error) in
//            // Check for the error, then data and try to create the image.
//        guard let responseData = data, let image = UIImage(data: responseData),
//              let blocks = self.loadingResponses[url], error == nil else {
//                  DispatchQueue.main.async {
//                      completion(item, nil)
//                  }
//                  return
//              }
//            // Cache the image.
//        self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
//            // Iterate over each requestor for the image and pass it back.
//        for block in blocks {
//            DispatchQueue.main.async {
//                block(item, image)
//            }
//            return
//        }
//    }.resume()
//}
