//
//  AUTextField.swift
//  AuthenticationManager
//
//  Created by srachha on 02/08/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

@IBDesignable
class AUTextField: AUSessionField {
    
    let TFPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.type = .Default
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setupFieldUI() -> Void {
        super.setupFieldUI()
        //self.textColor = UIColor.white
        //self.backgroundColor = UIColor.appFieldColor
        //self.font = UIFont.init(name: "CircularStd-Medium", size: 14)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, TFPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, TFPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, TFPadding)
    }

}
