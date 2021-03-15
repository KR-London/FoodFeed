//
//  profileCreatorViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class profileCreatorViewController: UIViewController {

    @IBOutlet var pageTitle: UILabel!
    
    @IBOutlet var nickname: UILabel!
    @IBOutlet var nameEntry: UITextField!
    
    @IBOutlet var describe: UILabel!
    @IBOutlet var describePicker: UIPickerView!
    
    @IBOutlet var goodAt: UILabel!
    @IBOutlet var goodAtPicker: UIPickerView!
    
    @IBOutlet var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSubviews()
        // Do any additional setup after loading the view.
    }

    
    func layoutSubviews(){
        
        let nameStack = UIStackView()
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.addArrangedSubview(nickname)
        nameStack.addArrangedSubview(nameEntry)
        nameStack.distribution = .fill
    
        view.addSubview(nameStack)
        
        let adjectiveStack = UIStackView()
        adjectiveStack.axis = .vertical
        adjectiveStack.alignment = .leading
        
        adjectiveStack.addArrangedSubview(describe)
        adjectiveStack.addArrangedSubview(describePicker)
        adjectiveStack.addArrangedSubview(goodAt)
        adjectiveStack.addArrangedSubview(goodAtPicker)
        adjectiveStack.addArrangedSubview(nextButton)
        
        view.addSubview(adjectiveStack)
        
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        adjectiveStack.translatesAutoresizingMaskIntoConstraints = false
        
        nameStack.topAnchor.constraint(equalTo: pageTitle.bottomAnchor).isActive = true
        nameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nameStack.bottomAnchor.constraint(equalTo: adjectiveStack.topAnchor, constant: -50).isActive = true
        
        nameEntry.translatesAutoresizingMaskIntoConstraints = false
        nameEntry.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nameEntry.placeholder = "Write here."
        
        //adjectiveStack.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        adjectiveStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adjectiveStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nextButton)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
