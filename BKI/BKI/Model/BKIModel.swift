//
//  BKIModel.swift
//  BKI
//
//  Created by srachha on 20/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit



class BKIModel: NSObject {
    
    var id:Int?
    var active:Bool = false
    //    var userRole:String?
    var spoolNumber:String?
    var state:WeldState?

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    convenience init(model:[String:AnyObject]) {
        self.init()
    }
    
    static func initUserdefsWithSuitName()-> UserDefaults! {
        guard let defs = UserDefaults(suiteName: "com.BKI.app")  else {
            return UserDefaults.init(suiteName: "com.BKI.app")
        }
        return defs
    }
    
    static func resetUserDefaults()->Void {
        let defs = BKIModel.initUserdefsWithSuitName()
        defs?.removeObject(forKey: "access-token")
        defs?.removeObject(forKey: "user_id")
        defs?.removeObject(forKey: "user_role")
        UserDefaults.standard.removeObject(forKey: "additional_users")
        defs?.set(false, forKey: "isLoggedIn")
    }
    
    static func userRole() -> String {
        let defs = BKIModel.initUserdefsWithSuitName()
        return (defs?.object(forKey: "role") as? String)!
    }
    
    static func saveUserinDefaults(info:[String:AnyObject])->Void {
        let defs = BKIModel.initUserdefsWithSuitName()
        defs?.set(info["user_id"], forKey: "user_id")
        defs?.set(info["role"],forKey: "role")
        defs?.set(true, forKey: "isLoggedIn")
        let loginUser = User.shared
        loginUser.saveUser(user: info)
    }
    
    static func isUserLoggedIn()->Bool {
        let defs = BKIModel.initUserdefsWithSuitName()
        return (defs?.bool(forKey: "isLoggedIn"))!
    }
    
    static func userId()->Int {
        let defs = BKIModel.initUserdefsWithSuitName()
        return (defs?.object(forKey: "user_id") as? Int)!
    }
    
    static func setSpoolNumebr(number:String?) {
        let defs = BKIModel.initUserdefsWithSuitName()
        guard number != nil else {
            defs?.removeObject(forKey: "code")
            return
        }
        defs?.set(number, forKey: "code")
    }
    
    static func spoolNumebr() -> String? {
        let defs = BKIModel.initUserdefsWithSuitName()
        guard let spool = defs?.object(forKey: "code") as? String else { return nil }
        return spool
    }
    
    func setModelState(state:String) {
        if state == "fitting" {
            self.state = WeldState.fitting
        }
        else if state == "welding" {
            self.state = WeldState.welding
        }
        else if state == "qa" {
            self.state = WeldState.qa
        }
        else if state == "ready_to_ship" {
            self.state = WeldState.readyToShip
        }
        else if state == "in_shipping" {
            self.state = WeldState.inShipping
        }
        else if state == "shipping" {
            self.state = WeldState.shipped
        }
        else if state == "verified" {
            self.state = WeldState.verified
        }
        else if state == "complete" {
            self.state = WeldState.complete
        }
        else if state == "reject" {
            self.state = WeldState.reject
        }
        
    }
    
    func getWeldState(state:WeldState) -> String {
        var status = ""
        switch state {
            case .fitting:
                status = "fitting"
                break;
            case .welding:
                status = "welding"
                break;
            case .qa:
                status = "qa"
                break;
            case .verified:
                status = "approved"
                break;
            case .complete:
                status = "approved"
                break;
            default:
                status = "reject"
                break;
        }
        return status
    }
}
