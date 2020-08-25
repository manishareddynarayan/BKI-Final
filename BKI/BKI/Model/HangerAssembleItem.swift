//
//  HangerAssembleItem.swift
//  BKI
//
//  Created by Narayan Manisha on 25/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class HangerAssembleItem:BKIModel {
    var quantity:String?
    var hangerNumber:String?
    var hangerSize:String?
    var desc:String?
    var rodWidth:String?
    var rodLengthA:String?
    var rodLengthB:String?
    var rodSize:String?
    var completed:Bool?

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveAssembleItem(itemInfo: info)
    }
    func saveAssembleItem(itemInfo:[String:AnyObject]) {
        if let id = itemInfo["id"] as? Int{
            self.id = id
        }
        if let hangerNumber = itemInfo["hanger_no"] as? String{
            self.hangerNumber = hangerNumber
        }
        if let quantity = itemInfo["quantity"] as? Int{
            self.quantity = String(quantity)
        }
        if let hangerSize = itemInfo["hanger_size"] as? String{
            self.hangerSize = hangerSize
        }
        if let desc = itemInfo["description"] as? String{
            self.desc = desc
        }
        if let rodWidth = itemInfo["rod_width"] as? String{
            self.rodWidth = rodWidth
        }
        if let rodLengthA = itemInfo["rod_length_a"] as? String{
            self.rodLengthA = rodLengthA
        }
        if let rodLengthB = itemInfo["rod_length_b"] as? String{
            self.rodLengthB = rodLengthB
        }
        if let completed = itemInfo["completed"] as? Bool{
                self.completed = completed
        }
    }
}
