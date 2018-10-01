//
//  WeldCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    var markAsCompletedBlock:(() -> Void)?
    var statusCompletedBlock:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.statusBtn.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func markAction(_ sender: Any) {
        self.markAsCompletedBlock!()
    }
    
    @IBAction func statusAction(_ sender: Any) {
        self.statusCompletedBlock!()
    }
}
