//
//  Part.swift
//  BKI
//
//  Created by srachha on 04/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Part: BKIModel {
    var name:String?
    var heatNumber:String = ""
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.savePart(partInfo: info)
    }
    
    func savePart(partInfo:[String:AnyObject]) {
        if let name = partInfo["name"] as? String {
            self.name = name
        }
        if let number = partInfo["number"] as? String {
            self.heatNumber = number
        }
    }
}
