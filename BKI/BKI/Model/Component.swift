//
//  Part.swift
//  BKI
//
//  Created by srachha on 04/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Component: BKIModel {
    
    var name:String?
    var heatNumber:String = ""
    var desc:String?
    var quantity:Int?
    var length:Int?
    var specificationId:Int?
    var recordId:Int?
    var group:String?
    var size:String?
    var schedule:String?
    weak var spool:Spool?

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.savePart(partInfo: info)
    }
    
    func savePart(partInfo:[String:AnyObject]) {
        if let id = partInfo["id"] as? Int {
            self.id = id
        }
        if let name = partInfo["name"] as? String {
            self.name = name
        }
        if let number = partInfo["heat_number"] as? String {
            self.heatNumber = number
        }
        if let description = partInfo["description"] as? String {
            self.desc = description
        }
        if let quantity = partInfo["quantity"] as? Int {
            self.quantity = quantity
        }
        if let length = partInfo["length"] as? Int {
            self.length = length
        }
        if let specificationId = partInfo["specificationId"] as? Int {
            self.specificationId = specificationId
        }
        if let recordId = partInfo["recordId"] as? Int {
            self.recordId = recordId
        }
        if let group = partInfo["group"] as? String {
            self.group = group
        }
        if let size = partInfo["size"] as? String {
            self.size = size
        }
        if let schedule = partInfo["schedule"] as? String {
            self.schedule = schedule
        }
    }
}
