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
        if state == "Approved" {
//            weld.isChecked = true
            self.statusLbl.textColor = UIColor.muddyGreen
        } else if state == "Fitting" {
            self.statusLbl.text = (weld.qARejectReason != nil && (weld.qARejectReason?.count)! > 0) ? "Rejected" : ""
            self.statusLbl.textColor = UIColor.scarlet
        }
        else {
            self.statusLbl.isHidden = true
        }
        self.isChecked = weld.isChecked
        self.setImageForCheckBtn()
    }
    
    @IBAction func checkMarkAction(_ sender: Any) {
        self.isChecked = !self.isChecked
        self.setImageForCheckBtn()
        self.selectionChangeddBlock!(self.isChecked)
    }
    
    private func setImageForCheckBtn() {
        let image = self.isChecked ? "Check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
    }
}
