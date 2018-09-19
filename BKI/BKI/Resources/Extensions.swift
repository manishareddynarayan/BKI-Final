//
//  Extensions.swift
//  BKI
//
//  Created by srachha on 19/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import Foundation

extension UIColor {
    
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 80.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brickRed: UIColor {
        return UIColor(red: 137.0 / 255.0, green: 13.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mahogany: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 6.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var darkRed: UIColor {
        return UIColor(red: 127.0 / 255.0, green: 11.0 / 255.0, blue: 1.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyish: UIColor {
        return UIColor(white: 173.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black: UIColor {
        return UIColor(white: 40.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var steel: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }
    
}

// Sample text styles

extension UIFont {
    
    class var header: UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: .bold)
    }
    
}
