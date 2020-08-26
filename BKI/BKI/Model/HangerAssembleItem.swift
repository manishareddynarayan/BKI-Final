//
//  HangerAssembleItem.swift
//  BKI
//
//  Created by Narayan Manisha on 25/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class HangerAssemble:BKIModel {
    var hangerState:String?
    var cuttingCompleted:Bool?
    var hangerAssembleItems = [HangerAssembleItem]()

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveAssembleItem(itemInfo: info)
    }
    func saveAssembleItem(itemInfo:[String:AnyObject]) {
        if let hangerState = itemInfo["hanger_state"] as? String{
            self.hangerState = hangerState
        }
        if let cuttingCompleted = itemInfo["cutting_completed"] as? Bool{
                self.cuttingCompleted = cuttingCompleted
        }
        if let items = itemInfo["hanger_items"] as? [[String:AnyObject]] {
            self.hangerAssembleItems.removeAll()
            for (_,bundle) in items.enumerated() {
                let newItem = HangerAssembleItem.init(info: bundle)
                self.hangerAssembleItems.append(newItem)
            }
        }
    }
}

class HangerAssembleItem:BKIModel {
    var quantity = ""
    var hangerNumber = ""
    var hangerSize = ""
    var desc = ""
    var rodWidth = ""
    var rodLengthA = ""
    var rodLengthB = ""
    var rodSize = ""
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
        if let rodSize = itemInfo["rod_size"] as? String{
            self.rodSize = rodSize
        }
        if let completed = itemInfo["completed"] as? Bool{
                self.completed = completed
        }
    }
}
