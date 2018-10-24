//
//  InspectionCell.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionCell: BaseCell {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var weldLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var isChecked = false
    var selectionChangeddBlock:((_ isChecked:Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWeld(weld:Weld) {
        self.weldLbl.text = weld.number
        let state = weld.getWeldState(state: weld.state!).capitalized
        self.statusLbl.text = state
        self.statusLbl.isHidden = false
        self.checkBtn.isHidden = true
        if state == "Approved" {
            self.statusLbl.textColor = UIColor.muddyGreen
        } else if state == "Reject" {
            self.statusLbl.textColor = UIColor.scarlet
        }
        else {
            self.statusLbl.isHidden = true
            self.checkBtn.isHidden = false
        }
        self.isChecked = weld.isChecked
        let image = self.isChecked ? "check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
    }
    
    @IBAction func checkMarkAction(_ sender: Any) {
        self.isChecked = !self.isChecked
        let image = self.isChecked ? "check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
        self.selectionChangeddBlock!(self.isChecked)
    }
    
}
