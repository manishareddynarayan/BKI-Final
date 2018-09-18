//
//  View_ext.swift
//  DrillLogs
//
//  Created by Sandeep Kumar Rachha on 23/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    
    func callContactPerson(number:String) -> Void {
        let phoneUrl = "tel://\(number)"
        let url:NSURL = NSURL(string: phoneUrl as String)!
        UIApplication.shared.openURL(url as URL)
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:0))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func emptyViewToHideUnNecessaryRowsOverButton() -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:100))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    

    
    func applyPrimaryTheme() -> Void {
        self.layer.cornerRadius = 13.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.appTheamColor().cgColor
    }
    func removePrimaryTheme() -> Void {
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0
    }
    
    
    func applyScecondaryBackGroundGradient() -> CAGradientLayer {
        
        let firstColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let secondColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let gradient : CAGradientLayer = self.createGradientlayer(firstColor:firstColor , secondColor: secondColor)

        self.layer.insertSublayer(gradient, at: 0)
        self.applyShadowatBottom()
        
        return gradient
    }
    
    
    func applyPrimaryBackGroundGradient() -> Void {
        
        let firstColor = UIColor.init(red: 231.0/255.0, green: 239.0/255.0, blue: 248.0/255.0, alpha: 1.0).cgColor
        let secondColor =  UIColor.init(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor
        let layer = self.createGradientlayer(firstColor: firstColor, secondColor:secondColor)
        
        self.layer.insertSublayer(layer, at: 0)
    }
    
    
    
    
    func applyShadowatBottom() -> Void {
        //self.layer.masksToBounds = false;
       // self.layer.cornerRadius = 4;
        self.layer.shadowOffset = CGSize(width:0, height:5);
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5;
    }

    func applyShadowatBottom(offset:CGSize?,radius:CGFloat?,opacity:Float?) -> Void {
        self.layer.masksToBounds = false;
        if offset != nil {
            self.layer.shadowOffset = offset!;
        }
        if radius != nil {
            self.layer.shadowRadius = radius!;
        }
        if opacity != nil {
            self.layer.shadowOpacity = opacity!;
        }
      
    }
    
    func resetPrimaryShadow() -> Void {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 0;
        self.layer.shadowOffset = CGSize(width:0, height:0);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
    }
    
    func applyPlainStyle() -> Void {
       
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 20;
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
    }
    
    
    func createGradientlayer(firstColor:CGColor,secondColor:CGColor) -> CAGradientLayer {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [firstColor, secondColor]

        return gradient
    }
    
    
    func createHorizantalGradientlayer(firstColor:CGColor,secondColor:CGColor) -> CAGradientLayer {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPoint(x:0,y:0.5)
        gradient.endPoint = CGPoint(x:1,y:0.5)
        
        return gradient
    }
    
    
    func createSliderGradient() -> UIImage {
        
        let firstColor = UIColor.init(red: 251.0/255.0, green: 143.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        let secondColor = UIColor.init(red: 29.0/255.0, green: 96.0/255.0, blue: 200.0/255.0, alpha: 1.0).cgColor
        let sliderGradient = self.createGradientlayer(firstColor: firstColor, secondColor: secondColor)
        sliderGradient.startPoint = CGPoint(x:0.0, y:0.5)
        sliderGradient.endPoint = CGPoint(x:1.0, y:0.5)

        UIGraphicsBeginImageContextWithOptions(sliderGradient.frame.size, sliderGradient.isOpaque, 0.0);
        sliderGradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image?.resizableImage(withCapInsets: UIEdgeInsets.zero)

        return image!
    }
    
    
    func getViewFromNib(nibName:String) -> UIView? {
        
        if let statusView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        {
            statusView.frame = self.bounds
            return statusView
        }
        
        return nil
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}


extension MBProgressHUD {
    static func showHud(view:UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)

    }
    
    
    static func hideHud(view:UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
