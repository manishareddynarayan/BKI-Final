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
    var loadId:Int?
    var drawingUrl:String?
    var materialName:String?
    var isArchivedOrRejected:Bool?
    var isWorking:Bool?
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
        if let loadId = hangerInfo["load_id"] as? Int{
            self.loadId = loadId
        }
        if let materialName = hangerInfo["material_name"] as? String{
            self.materialName = materialName
        }
        if let hangerState = hangerInfo["state"] as? String{
            self.hangerState = hangerState
        }
        if let drawingUrl = hangerInfo["drawing_url"] as? String{
            self.drawingUrl = drawingUrl
        }
        if let isArchivedOrRejected = hangerInfo["is_archived_or_rejected"] as? Bool {
            self.isArchivedOrRejected = isArchivedOrRejected
        }
        if let isWorking = hangerInfo["is_working"] as? Bool {
            self.isWorking = isWorking
        }
    }
}
