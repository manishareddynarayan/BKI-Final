//
//  WeldCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    var markAsCompletedBlock:(() -> Void)?
    var viewComments:(() -> Void)?
    var statusChangeddBlock:(() -> Void)?
    var isChecked = false
    var selectionChangedBlock:((_ isChecked:Bool) -> Void)?

    @IBOutlet weak var statusTF: AUTextField!
    let arr = [["Type":"Rolled","Value":1],["Type":"Position","Value":2],["Type":"Orbital","Value":3]]
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkBtn.isHidden = true
        self.statusTF.isHidden = true
        self.statusTF.textAlignment = .left
        self.statusTF.addPickerView(with: self)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onSelectWeld(_ sender: Any) {
        self.isChecked = !self.isChecked
        self.setImageForCheckBtn()
        self.selectionChangedBlock!(self.isChecked)
    }
    
    private func setImageForCheckBtn() {
        let image = self.isChecked ? "Check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
    }
    
    func configureWeldCell(weld:Weld) {
        self.nameLbl.text = weld.number
        self.statusTF.text = (weld.weldType != nil) ? weld.weldType : ""
        self.isChecked = weld.isChecked
        self.setImageForCheckBtn()
    }
    
    @IBAction func markAction(_ sender: Any) {
        self.markAsCompletedBlock!()
    }
    
    @IBAction func viewComments(_ sender: Any) {
        self.viewComments!()
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
