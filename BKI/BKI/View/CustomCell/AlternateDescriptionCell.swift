//
//  AlternateDescriptionCell.swift
//  BKI
//
//  Created by Anchal Kumar Gupta on 07/03/19.
//  Copyright © 2019 srachha. All rights reserved.
//

import UIKit

class AlternateDescriptionCell: BaseCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    
    func setCell(data:[[String:AnyObject]], index:Int){
        if data.count>1{
            if let heading = data[index + 1]["key"] as? String{
                headingLbl.text = heading.uppercased()
            }
            if let size = data[index + 1]["size"] as? String{
                sizeLbl.text = size
            }
            if let notes = data[index + 1]["item_notes"] as? String{
                notesLbl.text = notes
            }
            if let description = data[index + 1]["alternate_description"] as? String{
                descriptionLbl.text = description
            }
        }
    }
}
