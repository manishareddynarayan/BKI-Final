//
//  Material.swift
//  BKI
//
//  Created by srachha on 03/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Material: BKIModel {

    var quantity = 0
    var desc:String?
    var miscellaneousMaterialId:Int?
    var weight = 0.0
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveMaterial(materialInfo: info)
    }
    
    func saveMaterial(materialInfo:[String:AnyObject]) {
        if let miscellaneousMaterialId = materialInfo["material_id"] as? Int {
            self.miscellaneousMaterialId = miscellaneousMaterialId
        }
        if let id = materialInfo["id"] as? Int {
            self.id = id
        }
        if let desc = materialInfo["material"] as? String {
            self.desc = desc
        }
        if let quantity = materialInfo["quantity"] as? Int {
            self.quantity = quantity
        }
        if let weightInfo = materialInfo["weight"] as? String {
            let weight = Double(weightInfo)
            self.weight = weight!
        }
    }
}
