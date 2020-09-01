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
    
    var firstName:String!
    var lastName:String!
    var name:String?
    var invitationStatus:Bool = false
    var email:String?
    var userName:String?
    var mobile:String?
    var role:Role!
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
    }
    
    func saveUser(user:[String:AnyObject]) {
        if let name = user["name"] as? String {
            self.name = name
        }
        if let id = user["user_id"] as? Int {
            self.id = id
        }
        if let first_name = user["first_name"] as? String {
            self.firstName = first_name
        }
        if let last_name = user["last_name"] as? String {
            self.lastName = last_name
        }
        if let invitation_status = user["invitation_status"] as? Bool {
            self.invitationStatus = invitation_status
        }
        if let active = user["active"] as? Bool {
            self.active = active
        }
        if let email = user["email"] as? String {
            self.email = email
        }
        if let mobile = user["mobile"] as? String {
            self.mobile = mobile
        }
        
        if let user_name = user["user_name"] as? String {
            self.userName = user_name
        }
        
        if let role = user["role"] as? String {
            self.setUserRole(role: role)
        }
    }
    
    func setUserRole(role:String) {
        if role == "fab_fitter" {
            self.role = Role.fitter
        }
        if role == "fab_welder" {
            self.role = Role.welder
        }
        if role == "Shipper" {
            self.role = Role.shipper
        }
    }
    
    func getUserMenuItems(with role:Int) -> [[String:String]] {
        switch (role) {
        case 1 :
            return self.getFitterMenu()
        case 2 :
            return self.getWelderMenu()
        case 3 :
            return self.getShippingMenu()
        default:
            return self.getTestingMenu()
        }
    }
    
    func getFitterMenu() -> [[String:String]] {
        return [["Name":"Status Fit-Up","Child":"WeldStatusVC"],
                ["Name":"Heat Numbers","Child":"FitterHeatVC"],
                ["Name":"View Spool Drawing","Child":"DrawingVC"],
                ["Name":"View ISO Drawing","Child":"DrawingVC"],
                ["Name":"Scan New Spool","Child":"ScanVC"]]
    }

    func getWelderMenu() -> [[String:String]] {
        return [["Name":"Status Welds","Child":"WeldStatusVC"],
         ["Name":"View Spool Drawing","Child":"DrawingVC"],
         ["Name":"View ISO Drawing","Child":"DrawingVC"],
         ["Name":"Scan New Spool","Child":"ScanVC"]]
    }
    
    func getShippingMenu() -> [[String:String]] {
        return [["Name":"New Load","Child":"NewLoadVC"],
         ["Name":"Open Loads","Child":"OpenLoadVC"]]
    }
    
    func getTestingMenu() -> [[String:String]] {
        return [["Name":"Inspection","Child":"InspectionVC"],
                ["Name":"View Spool Drawing","Child":"DrawingVC"],
                ["Name":"View ISO Drawing","Child":"DrawingVC"],
                ["Name":"Scan New Spool","Child":"ScanVC"]]
    }
    
    func getHangersMenu() -> [[String:String]] {
           return [["Name":"Cut Rods","Child":"WeldStatusVC"],
                   ["Name":"Cut Strut","Child":"FitterHeatVC"],
                   ["Name":"Assemble","Child":"DrawingVC"]]
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
        if roleName == "fitter" || roleName == "Fitter" {
            return Role.fitter
        } else if roleName == "welder" || roleName == "Welder" {
            return Role.welder
        }
        return Role.shipper
    }
}
