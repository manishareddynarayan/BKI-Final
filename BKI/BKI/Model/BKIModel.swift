//
//  BKIModel.swift
//  BKI
//
//  Created by srachha on 20/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

enum Role:Int {
    case fitter = 1
    case welder
    case shipper
}

class BKIModel: NSObject {
    
    var id:Int?
    //    var userRole:String?
    
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
        defs?.set(false, forKey: "isLoggedIn")
    }
    
    static func getUserRole() -> String {
        let defs = BKIModel.initUserdefsWithSuitName()
        return (defs?.object(forKey: "user_role") as? String)!
    }
    
    static func saveUserinDefaults(info:[String:AnyObject])->Void {
        let defs = BKIModel.initUserdefsWithSuitName()
        defs?.set(info["id"], forKey: "user_id")
        defs?.set(info["role"],forKey: "user_role")
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
    
    
}
