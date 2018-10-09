//
//  Weld.swift
//  BKI
//
//  Created by srachha on 04/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class Weld: BKIModel {

    weak var spool:Spool?
    var number:String?
    var recordid:String?
    var weldType:String?
    var weldSpec:String?
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveWeld(weldInfo: info)
    }
    
    func saveWeld(weldInfo:[String:AnyObject]) {
        
        if let id = weldInfo["id"] as? Int {
            self.id = id
        }
        if let number = weldInfo["number"] as? String {
            self.number = number
        }
        if let recordid = weldInfo["recordid"] as? String {
            self.recordid = recordid
        }
        if let weldType = weldInfo["weld_type"] as? String {
            self.weldType = weldType
        }
        if let weldSpec = weldInfo["weld_spec"] as? String {
            self.weldSpec = weldSpec
        }
        if let state = weldInfo["state"] as? String {
            self.setModelState(state: state)
        }
    }
}
