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
    
    func setCell(heading: String, size: String, notes: String, description: String){
        headingLbl.text = heading
        sizeLbl.text = size
        descriptionLbl.text = description
        notesLbl.text = notes
    }
}
