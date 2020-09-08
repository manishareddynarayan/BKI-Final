//
//  PackageBundle.swift
//  BKI
//
//  Created by Narayan Manisha on 19/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class PackageBundle:BKIModel {
    var size:String?
    var desc:String?
    var packageName:String?
    var materialName:String?
    var bundles = [PackageBundleData]()
    var assemblyDidStart = false
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.savePackageBundle(packageInfo: info)
    }
    
    func savePackageBundle(packageInfo:[String:AnyObject]) {
        if let size = packageInfo["info"]?["size"] as? String{
            self.size = size
        }
        if let material = packageInfo["material_name"] as? String{
            self.materialName = material
        }
        if let packageName = packageInfo["package_name"] as? String{
            self.packageName = packageName
        }
        if let assemblyDidStart = packageInfo["assembly_started"] as? Bool{
            self.assemblyDidStart = assemblyDidStart
        }
        if let desc = packageInfo["info"]?["description"] as? String{
            self.desc = desc
        }
        if let bundles = packageInfo["bundle_infos"] as? [[String:AnyObject]] {
            self.bundles.removeAll()
            for (_,bundle) in bundles.enumerated() {
                let newBundle = PackageBundleData.init(info: bundle)
                self.bundles.append(newBundle)
            }
        }
    }
}

class PackageBundleData:BKIModel {
    var cuts = [String]()
    var wastage:String?
    var numberOfCuts:Int?
    var numberOfRods:Int?
    var completed = false
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.savePackageBundleData(packageInfo: info)
    }
    
    func savePackageBundleData(packageInfo:[String:AnyObject]) {
        if let id = packageInfo["id"] as? Int{
            self.id = id
        }
        if let patterns = packageInfo["pattern"] as? [Float] {
            self.cuts.removeAll()
            var count = 0
            for pattern in patterns {
                count += 1
                self.cuts.append("Cut \(count): \(pattern)")
            }
        }
        if let numberOfRods = packageInfo["number_of_rods"] as? Int{
            self.numberOfRods = numberOfRods
        }
        if let numberOfCuts = packageInfo["number_of_cuts"] as? Int{
            self.numberOfCuts = numberOfCuts
        }
        if let completed = packageInfo["completed"] as? Bool{
            self.completed = completed
        }
    }
}
