//
//  Weld.swift
//  BKI
//
//  Created by srachha on 04/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Weld: BKIModel {

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveWeld(weldInfo: info)
    }
    
    func saveWeld(weldInfo:[String:AnyObject]) {
        
    }
}
