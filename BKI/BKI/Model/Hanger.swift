//
//  Hanger.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class Hanger: BKIModel {
    var packageName:String?
    var packageId:Int?
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveHanger(hangerInfo: info)
    }
    func saveHanger(hangerInfo:[String:AnyObject]) {
        if let id = hangerInfo["id"] as? Int{
            self.id = id
        }
        if let packageName = hangerInfo["packageID"] as? String{
            self.packageName = packageName
        }
        if let packageId = hangerInfo["package_id"] as? Int{
            self.packageId = packageId
        }
    }
}
