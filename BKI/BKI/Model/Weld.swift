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
    var weldMethod:String?
    var isChecked = false
    var qARejectReason:String?
    var welderRejectReason:String?
    var testMethod:String?
    var gasId:String?
    
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
        if let weldMethod = weldInfo["weld_method"] as? String {
            self.weldMethod = weldMethod
        }
        if let state = weldInfo["state"] as? String {
            self.setModelState(state: state)
        }
        if let welder_Reject_Reason = weldInfo["welding_reject_reason"] as? String {
            self.welderRejectReason = welder_Reject_Reason
        }
        if let qa_reject_reason = weldInfo["qa_reject_reason"] as? String {
            self.qARejectReason = qa_reject_reason
        }
        if let testMethod = weldInfo["test_method"] as? String {
            self.testMethod = testMethod
        }
        if let gasId = weldInfo["backing_gas_id"] as? String {
            self.gasId = gasId
        }
    }
}
