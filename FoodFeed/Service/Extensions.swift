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
    static let mainBackground = UIColor(hexString: "#EDEDF1")
        //#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let postBackground = UIColor(hexString: "#EDEDF1")
        //#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    //UIColor(hexString: "#EDEDF1")
    
    static let textTint = UIColor(hexString: "#745ff2")
    
    static let option1 = UIColor(hexString: "#ED5050")
    static let option2 = UIColor(hexString: "#F08523")
    static let option3 = UIColor(hexString: "#1785EB")
    static let dunno = UIColor(hexString: "#00BFB7")
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
