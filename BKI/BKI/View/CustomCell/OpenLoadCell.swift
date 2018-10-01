//
//  OpenLoadCell.swift
//  BKI
//
//  Created by srachha on 01/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class OpenLoadCell: BaseCell {

    @IBOutlet weak var loadLbl: UILabel!
    
    var loadEditBlock:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editAction(_ sender: Any) {
        self.loadEditBlock!()

    }
    
    
}
