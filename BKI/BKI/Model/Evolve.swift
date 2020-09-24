//
//  Evolve.swift
//  BKI
//
//  Created by Narayan Manisha on 22/09/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class Evolve: BKIModel {
    var packageId:Int?
    var batteryName:String?
    var evolveState:String?
    var isArchivedOrRejected:Bool?
    var rejectReason:String?
    var drawingUrl:String?
    var isInFabrication:Bool?
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveEvolve(evolveInfo: info)
    }

    func saveEvolve(evolveInfo:[String:AnyObject]) {
        if let id = evolveInfo["id"] as? Int{
            self.id = id
        }
        if let packageId = evolveInfo["package_id"] as? Int{
            self.packageId = packageId
        }

        if let batteryName = evolveInfo["battery_name"] as? String {
            self.batteryName = batteryName
        }
        if let evolveState = evolveInfo["state"] as? String {
            self.evolveState = evolveState
        }
        if let rejectReason = evolveInfo["reject_reason"] as? String {
            self.rejectReason = rejectReason
        }
        if let drawingUrl = evolveInfo["drawing_url"] as? String {
            self.drawingUrl = drawingUrl
        }
        if let isArchivedOrRejected = evolveInfo["is_archived_or_rejected"] as? Bool {
            self.isArchivedOrRejected = isArchivedOrRejected
        }
        if let isInFabrication = evolveInfo["can_ios_access"] as? Bool {
            self.isInFabrication = isInFabrication
        }
    }
}
