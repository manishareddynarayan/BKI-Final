//
//  AUEmailField.swift
//  AuthenticationManager
//
//  Created by srachha on 01/08/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

@IBDesignable
class AUEmailField: AUSessionField {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.type = .Email
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
        self.keyboardType = .emailAddress
    }
}


