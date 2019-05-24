//
//  Load.swift
//  BKI
//
//  Created by srachha on 03/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Load: BKIModel {

    var number:String?
    var status:String?
    var spools = [Spool]()
    var materials = [Material]()
    var truckNumber:String?
    var total_weight = 0.0
    var projectId:Int?
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveLoad(loadInfo: info)
    }
    
    func saveLoad(loadInfo:[String:AnyObject]) {
       
        if let id = loadInfo["load_id"] as? Int {
            self.id = id
        }
        if let truckNumber = loadInfo["truck_number"] as? String {
            self.truckNumber = truckNumber
        }else{
            self.truckNumber = ""
        }
            
        if let number = loadInfo["load_number"] as? String {
            self.number = number
        }
        
        if let status = loadInfo["load_status"] as? String {
            self.status = status
        }
        
        if let weight = loadInfo["total_weight"]?.doubleValue {
            self.total_weight = weight
        }
        
        if let projectId = loadInfo["project_id"] as? Int {
            self.projectId = projectId
        }
        
        self.spools.removeAll()
        if let spools = loadInfo["spools"] as? [[String:AnyObject]] {
            for (_,spool) in spools.enumerated() {
                let newSpool = Spool.init(info: spool)
                self.spools.append(newSpool)
            }
        }
        self.materials.removeAll()
        if let materials = loadInfo["loads_materials"] as? [[String:AnyObject]] {
            for (_,material) in materials.enumerated() {
                let newMaterial = Material.init(info: material)
                self.materials.append(newMaterial)
            }
        }
    }
}
