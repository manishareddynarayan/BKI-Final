//
//  Solution.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class Solution:BKIModel {
    var name:String?
    var totalWastage:String?
    var totalCuts:String?
    var numberOfRods:String?
    var numberOfBundles:String?

    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        self.saveSolution(solutionInfo: info)
    }
    func saveSolution(solutionInfo:[String:AnyObject]) {
        if let id = solutionInfo["nest_id"] as? Int{
            self.id = id
        }
        if let name = solutionInfo["algorithm_name"] as? String{
            self.name = name
        }
        if let totalWastage = solutionInfo["total_wastage"] as? Int{
            self.totalWastage = String(totalWastage)
        }
        if let totalCuts = solutionInfo["total_no_of_cuts"] as? Int{
            self.totalCuts = String(totalCuts)
        }
        if let numberOfRods = solutionInfo["no_of_rods"] as? Int{
            self.numberOfRods = String(numberOfRods)
        }
        if let numberOfBundles = solutionInfo["no_of_bundles"] as? Int{
            self.numberOfBundles = String(numberOfBundles)
        }
    }
}
