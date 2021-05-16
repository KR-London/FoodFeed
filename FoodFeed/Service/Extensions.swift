//
//  Extensions.swift
//  FoodFeed
//
//  Created by Kate Roberts on 15/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import Foundation
import UIKit
import SoftUIView

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


/// TODO: When this is subclassed from UI Button ( as per the version in 'main' it works nicely to have buttons popping up periodically to make the app more interactive.
//// I want the 'look' of these buttons to match the UI slide deck. Plan was to subclass SoftUIView - as per the examples in the documentation of making this like a button - and then add the colour outlines etc. It doesn't work though!!! No button shows up! Help! 
class MediaButton: SoftUIView {
    var video:String = ""
    var answer:String = ""
    var titleLabel = UILabel()
    
    convenience init(video: String) {
        self.init()
        self.video = video
        self.answer = answer
    }
    
    convenience init() {
        self.init(frame: .init(x: 100, y: 100, width: 200, height: 200))
        type = .pushButton
    }
    
    
    func laurenFormat(position: Int){
        self.mainColor = UIColor.brown.cgColor
        self.cornerRadius = 50
        self.darkShadowColor = UIColor.black.cgColor
        self.lightShadowColor = UIColor.yellow.cgColor
        self.shadowOpacity = 0.5
        self.shadowOffset = .init(width: -6, height: 6)
        self.shadowRadius = 10
    }
    
    func setTitle(text: String) {
      //  subtitleView.type = .normal
   
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .darkText
       // titleLabelfont = UIFont.init(name: "AvenirNext-Regular", size: 16)
        
        titleLabel.text = text
        
        self.setContentView(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}



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
