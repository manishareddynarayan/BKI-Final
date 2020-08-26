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
    
    @nonobjc class var muddyGreen: UIColor {
        return UIColor(red: 87.0 / 255.0, green: 120.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var scarlet: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var appRed: UIColor {
        return UIColor(red: 127.0 / 255.0, green: 11.0 / 255.0, blue: 1.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var cellBackGroundDark: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 173.0 / 255.0, blue: 173.0 / 255.0, alpha: 0.3)
    }
    @nonobjc class var cellBackGroundLight: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 173.0 / 255.0, blue: 173.0 / 255.0, alpha: 0.1)
    }
}

// Sample text styles

extension UIFont {
    
    class var header: UIFont {
        return UIFont.systemFont(ofSize: 24.0, weight: .bold)
    }
    
    class var systemMedium17: UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    class var systemSemiBold15: UIFont {
        return UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    }
}
