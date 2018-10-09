//
//  Spool.swift
//  BKI
//
//  Created by srachha on 03/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Spool: BKIModel {
    var code:String?
    var complete:Bool?
    var status:String?
    var packageId:Int?
    var packageID: Int?
    var archive = false
    var welds = [Weld]()
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveSpool(spoolInfo: info)
    }
    
    func saveSpool(spoolInfo:[String:AnyObject]) {
        if let id = spoolInfo["id"] as? Int {
            self.id = id
        }
        if let code = spoolInfo["spool_id"] as? String {
            self.code = code
        }
        if let complete = spoolInfo["complete"] as? Bool {
            self.complete = complete
        }
        if let status = spoolInfo["status"] as? String {
            self.status = status
        }
        if let state = spoolInfo["state"] as? String {
            self.setModelState(state: state)
        }
        if let packageId = spoolInfo["package_id"] as? Int {
            self.packageId = packageId
        }
        if let packageID = spoolInfo["packageID"] as? Int {
            self.packageID = packageID
        }
        if let archive = spoolInfo["archive"] as? Bool {
            self.archive = archive
        }
        if let weldsArr = spoolInfo["welds"] as? [[String:AnyObject]] {
            for weldInfo in weldsArr {
                let weld = Weld.init(info: weldInfo)
                weld.spool = self
                self.welds.append(weld)
            }
        }
    }
}
