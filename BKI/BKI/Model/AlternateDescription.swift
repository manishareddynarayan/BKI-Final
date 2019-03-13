//
//  AlternateDescription.swift
//  BKI
//
//  Created by Anchal Kumar Gupta on 12/03/19.
//  Copyright © 2019 srachha. All rights reserved.
//

import UIKit

class AlternateDescription: BKIModel {
    
    var heading:String?
    var size:String?
    var notes:String?
    var altDescription:String?
    
    override init() {
        super.init()
    }
    
    init(key:String,values:[String:AnyObject]) {
        self.heading = key.uppercased()
        
        if let size = values["size"] as? String{
            self.size = size
        }else{
            self.size = "-"
        }
        if let notes = values["notes"] as? String{
            self.notes = notes
        }else{
            self.notes = "-"
        }
        if let description = values["alternate_description"] as? String{
            self.altDescription = description
        }else{
            self.altDescription = "-"
        }
    }
}
