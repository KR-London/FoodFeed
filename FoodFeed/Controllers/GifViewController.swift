//
//  GifViewController.swift
//  FoodFeed


import UIKit
import GiphyUISDK

class GifViewController: UIViewController {
    
    let mediaView = GPHMediaView()

    override func viewDidLoad() {
        super.viewDidLoad()

        Giphy.configure(apiKey: giphyAPIKey)

        GiphyCore.shared.gifByID("Y1M0ZSlt5fDhvj4Zz5") { (response, error) in
            if let media = response?.data {
                DispatchQueue.main.sync { [weak self] in
                    self?.mediaView.media = media
                }
            }
        }

        view.addSubview(mediaView)
        
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        
        mediaView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        mediaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        mediaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
