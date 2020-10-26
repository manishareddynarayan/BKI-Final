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
    var components = [Component]()
    var pdfUrl:String?
    var isoDrawingURL:String?
    var loadedAt:String?
    var weight = 0.0
    var projectId:Int?
    var lastFittingCompletion = false
    var IDTestMethods:[String:Int] = [:]
    var ODTestMethods:[String:Int] = [:]
    var isStainlessSteel:Bool?
    var isCutListsCompleted:Bool?
    var isHPCategory:Bool?
    var isArchivedOrRejected:Bool?
    var isWorking:Bool?
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveSpool(spoolInfo: info)
    }
    
    func saveSpool(spoolInfo:[String:AnyObject]) {
        if let id = spoolInfo["id"] as? Int{
            self.id = id
        }
        if let id = spoolInfo["spool_id"] as? Int{
            self.id = id
        }
        if let code = spoolInfo["code"] as? String {
            self.code = code
        }
        if let complete = spoolInfo["complete"] as? Bool {
            self.complete = complete
        }
        if let status = spoolInfo["status"] as? String {
            self.status = status
        }
        if let drawing_url = spoolInfo["drawing_url"] as? String {
            self.pdfUrl = drawing_url
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
            self.saveWelds(welds: weldsArr)
        }
        if let compoenents = spoolInfo["components"] as? [[String:AnyObject]] {
            self.saveComponents(components: compoenents)
        }
        if let loadedAt = spoolInfo["loaded_at"] as? String{
            self.loadedAt = loadedAt
        }
        if let weight = spoolInfo["weight"] as? String{
            self.weight = Double(weight)!
        }
        if let projectId = spoolInfo["project_id"] as? Int{
            self.projectId = projectId
        }
        if let testMethods = spoolInfo["id_test_methods"] as? [String:Int]{
            for (key, value) in testMethods{
                self.IDTestMethods[key] = value
            }
        }
        if let testMethods = spoolInfo["od_test_methods"] as? [String:Int]{
            for (key, value) in testMethods{
                self.ODTestMethods[key] = value
            }
        }

        if let isStainlessSteel = spoolInfo["stainless_steel?"] as? Bool{
            self.isStainlessSteel = isStainlessSteel
        }
        if let isCutListsCompleted = spoolInfo["cut_lists_completed?"] as? Bool{
            self.isCutListsCompleted = isCutListsCompleted
        }
        if let isoDrawingUrl = spoolInfo["iso_drawing_url"] as? String {
            self.isoDrawingURL = isoDrawingUrl
        }
        if let isArchivedOrRejected = spoolInfo["is_archived_or_rejected"] as? Bool {
            self.isArchivedOrRejected = isArchivedOrRejected
        }
        if let meterilaUrl = spoolInfo["material"] as? String {
            self.isHPCategory = (meterilaUrl == "HP")
        }
        if let isWorking = spoolInfo["is_working"] as? Bool {
            self.isWorking = isWorking
        }
    }
    
    func saveComponents(components:[[String:AnyObject]]) {
        self.components.removeAll()
        for component in components {
            let comp = Component.init(info: component)
            comp.spool = self
            self.components.append(comp)
        }
    }
    
    func saveWelds(welds:[[String:AnyObject]]) {
        self.welds.removeAll()
        for weldInfo in welds {
            let weld = Weld.init(info: weldInfo)
            weld.spool = self
            self.welds.append(weld)
        }
    }
    
}
