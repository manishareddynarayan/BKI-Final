//
//  Color.swift
//  UOVO
//
//  Created by srachha on 02/05/18.
//  Copyright © 2018 UOVO. All rights reserved.
//

import UIKit

class Color: UIColor {
    
    static var inProgressTextColor: UIColor  =  UIColor(red: 190.0/255.0, green: 119.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static var inProgressBackgroundColor: UIColor  =  UIColor(red: 244.0/5.0, green: 166.0/255.0, blue: 36.0/255.0, alpha: 0.19)
    
    static var blockedTextColor: UIColor  =  UIColor(red: 208.0/255.0, green: 2.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    static var blockedBackgroundColor: UIColor  =  UIColor(red: 246.0/255.0, green: 212.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    
    static var completedTextColor: UIColor  =  UIColor(red: 65.0/255.0, green: 117.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    static var completedBackgroundColor: UIColor  =  UIColor(red: 200.0/255.0, green: 222.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    
    static var notStartedTextColor: UIColor  =  UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 1.0)
    static var notStartedBackgroundColor: UIColor  =  UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    
    static var pausedTextColor: UIColor  =  Color.hexStringToUIColor(hex: "#CF7643")
    static var pausedBackgroundColor: UIColor  =  Color.hexStringToUIColor(hex: "#F2D9CA")
    
    static var rejectedTextColor: UIColor  =  Color.hexStringToUIColor(hex: "#C54444")
    static var rejectedBackgroundColor: UIColor  =  Color.hexStringToUIColor(hex: "#EDC6C6")
    
    static var pendingTextColor: UIColor  =  Color.hexStringToUIColor(hex: "#4ABCE2")
    static var pendingBackgroundColor: UIColor  =  Color.hexStringToUIColor(hex: "#DCF2F9")
    
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func squashColor() -> UIColor {
        return Color.hexStringToUIColor(hex:"#f5a623");
    }
    
    class func secondarysquashColor() -> UIColor {
        let color = Color.hexStringToUIColor(hex:"#f5a623");
        color.withAlphaComponent(0.9)
        return color;
    }
    
    class var offWhite: UIColor {
        return UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    }
    
    
    class var docRed: UIColor {
        return UIColor(red: 255.0/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    }
    
    class var statusPink: UIColor {
        return UIColor(red: 255.0/255.0, green: 101.0/255.0, blue: 101.0/255.0, alpha: 1.0)
    }
    
    class var disable: UIColor {
        return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 0.23)
    }
    class var statusGray: UIColor {
        return UIColor(red: 91.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1)
    }

}
