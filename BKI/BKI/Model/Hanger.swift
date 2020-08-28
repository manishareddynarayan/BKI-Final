//
//  Hanger.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class Hanger: BKIModel {
    var packageName:String?
    var hangerState:String?
    var packageId:Int?
    var drawingUrl:String?
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveHanger(hangerInfo: info)
    }
    func saveHanger(hangerInfo:[String:AnyObject]) {
        if let id = hangerInfo["hanger_id"] as? Int{
            self.id = id
        }
        if let packageName = hangerInfo["package_name"] as? String{
            self.packageName = packageName
        }
        if let packageId = hangerInfo["package_id"] as? Int{
            self.packageId = packageId
        }
        if let hangerState = hangerInfo["state"] as? String{
            self.hangerState = hangerState
        }
        if let drawingUrl = hangerInfo["drawing_url"] as? String{
            self.drawingUrl = drawingUrl
        }
    }
}
