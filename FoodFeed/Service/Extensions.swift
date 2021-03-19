//
//  Extensions.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit

//// Put this piece of code anywhere you like
//extension UIViewController {
//    func stopsInteractionWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UIColor{
    static let xeniaGreen = UIColor(red: 146/255, green: 222/255, blue: 206/255, alpha: 1)
    //  static let xeniaGreen = UIColor(red: 186/255, green: 242/255, blue: 206/255, alpha: 1)
    static let mainBackground =  #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let postBackground =  #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
}
