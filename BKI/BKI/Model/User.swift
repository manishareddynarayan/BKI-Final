//
//  User.swift
//  BKI
//
//  Created by srachha on 20/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class User: BKIModel {

    static let shared = User()
    
    var name:String!
    var email:String!
    var mobile:String!
    var emp_code:String!
    var role:Role!
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
    }
    
    
    func saveUser(user:[String:AnyObject]) {
        
    }
    
    
    func getUserMenuItems() -> [[String:String]] {
        var roleItems: [[String:String]]!
        if role == Role.fitter{
            roleItems = [["Name":"Status Fit-Up","Child":"DashboardVC"],["Name":"Heat Numbers","Child":"tasksVC"],["Name":"View Drawing","Child":"employeesVC"],["Name":"Scan New Spool","Child":"profileVC"]]
        } else if role == Role.welder{
            roleItems = [["Name":"Status Welds","Child":"DashboardVC"],["Name":"View Drawing","Child":"tasksVC"],["Name":"Scan New Spool","Child":"profileVC"]]
        } else {
            roleItems = [["Name":"New Load","Child":"dashboardVC"],["Name":"Open Loads","Child":"profileVC"]]
        }
        return roleItems
    }
    
    class func getRoleName(userRole:Role) -> String {
        if userRole == Role.fitter {
            return "Fitter"
        } else if userRole == Role.welder {
            return "Welder"
        }
        return "Shipper"
    }
    
    class func getRole(roleName:String) -> Role {
        if roleName == "fitter" || roleName == "Fitter"{
            return Role.fitter
        } else if roleName == "welder" || roleName == "Welder" {
            return Role.welder
        }
        return Role.shipper
    }
}
