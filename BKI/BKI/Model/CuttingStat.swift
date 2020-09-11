//
//  CuttingStat.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class CuttingStat: BKIModel {
    var size:String!
    var desc:String?
    var isSolutionSelected:Bool = false
    var bundlesCompleted:Bool = false
    var solutions = [Solution]()
    
    override init () {
        // uncomment this line if your class has been inherited from any other class
        super.init()
    }
    
    convenience init(info:[String:AnyObject]) {
        self.init()
        saveCuttingStat(statInfo:info)
    }
    func saveCuttingStat(statInfo:[String:AnyObject]) {
        if let id = statInfo["cutting_stat_id"] as? Int{
            self.id = id
        }
        if let size = statInfo["info"]?["size"] as? String{
            self.size = size
        }
        if let description = statInfo["info"]?["description"] as? String{
            self.desc = description
        }
        if let isSolutionSelected = statInfo["solution_selected"] as? Bool {
            self.isSolutionSelected = isSolutionSelected
        }
        if let bundlesCompleted = statInfo["bundles_completed"] as? Bool {
            self.bundlesCompleted = bundlesCompleted
        }
        self.solutions.removeAll()
        if let solutions = statInfo["solutions"] as? [[String:AnyObject]] {
            for (_,solution) in solutions.enumerated() {
                let newsolution = Solution.init(info: solution)
                self.solutions.append(newsolution)
            }
        }
    }
}

