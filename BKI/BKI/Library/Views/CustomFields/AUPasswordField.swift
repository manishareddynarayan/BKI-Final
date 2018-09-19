//
//  AUPasswordField.swift
//  AuthenticationManager
//
//  Created by srachha on 01/08/17.
//  Copyright © 2017 srachha. All rights reserved.
//

import UIKit

@IBDesignable
class AUPasswordField: AUSessionField {

    @IBInspectable var secureImage:String = "Lock" {
        didSet {
            //self._required = isRequired
            let secureBtn = UIButton.init(type: .custom)
            secureBtn.setImage(UIImage.init(named: secureImage), for: .normal)
            secureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
            secureBtn.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            secureBtn.addTarget(self, action: #selector(self.showSecuredTextAction), for: .touchUpInside)
            self.rightView = secureBtn
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var unSecureImage:String = "UnLock" {
        didSet {
            
        }
    }
    
    
    @objc func showSecuredTextAction(_ sender: Any) -> Void{
        
        self.isSecureTextEntry = !self.isSecureTextEntry
        
        let secureBtn = self.rightView as? UIButton
        
        guard  self.isSecureTextEntry else {
            secureBtn?.setImage(UIImage.init(named: unSecureImage), for: .normal)
            return
        }
        secureBtn?.setImage(UIImage.init(named: secureImage), for: .normal)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //self.isSecureTextEntry = true
        self.type = .Password
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
    }
}
