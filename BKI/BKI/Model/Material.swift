//
//  Material.swift
//  BKI
//
//  Created by srachha on 03/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Material: NSObject {

    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveMaterial(materialInfo: info)
    }
    
    func saveMaterial(materialInfo:[String:AnyObject]) {
        
    }
}
