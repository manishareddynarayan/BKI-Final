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
    
    func setCell(data:AlternateDescription){
        headingLbl.text = data.heading!
        sizeLbl.text = data.size!
        notesLbl.text = data.notes!
        descriptionLbl.text = data.altDescription!
    }
}
