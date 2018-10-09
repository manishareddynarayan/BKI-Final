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
    var weld_type:String?
    var weld_spec:String?
    var state:WeldState?
    
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
        if let weld_type = weldInfo["weld_type"] as? String {
            self.weld_type = weld_type
        }
        if let weld_spec = weldInfo["weld_spec"] as? String {
            self.weld_spec = weld_spec
        }
        if let state = weldInfo["state"] as? String {
            if state == "fitting" {
                self.state = WeldState.fitting
            }
            if state == "welding" {
                self.state = WeldState.welding
            }
            if state == "qa" {
                self.state = WeldState.qa
            }
            if state == "complete" {
                self.state = WeldState.complete
            }
            if state == "reject" {
                self.state = WeldState.reject
            }
        }
    }
}
