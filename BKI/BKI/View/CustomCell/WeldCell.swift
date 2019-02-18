//
//  WeldCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var completeBtn: UIButton!
    var markAsCompletedBlock:(() -> Void)?
    var statusChangeddBlock:(() -> Void)?

    @IBOutlet weak var statusTF: AUTextField!
    let arr = [["Type":"Rolled","Value":1],["Type":"Position","Value":2],["Type":"Orbital","Value":3]]
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.statusTF.isHidden = true
        self.statusTF.textAlignment = .left
        self.statusTF.addPickerView(with: self)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWeldCell(weld:Weld) {
        self.nameLbl.text = weld.number
        self.statusTF.text = (weld.weldType != nil) ? weld.weldType : ""
    }
    
    @IBAction func markAction(_ sender: Any) {
        self.markAsCompletedBlock!()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let statusDict = arr[row]
        guard let type = statusDict["Type"] as? String else {
            return
        }
        self.statusTF.text = type
        self.statusChangeddBlock!()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.completeBtn.isEnabled = true
        statusTF.text = arr[0]["Type"] as? String
        self.statusChangeddBlock!()
        let statusDict = arr[row]
        return statusDict["Type"] as? String
    }
}
