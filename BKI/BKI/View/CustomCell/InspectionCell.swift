//
//  InspectionCell.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionCell: BaseCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var weldLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var testMethodChangeddBlock:((_ testMethod:String) -> Void)?
    @IBOutlet weak var testMethodTF: AUTextField!
    
    var isChecked = false
    var selectionChangeddBlock:((_ isChecked:Bool) -> Void)?
    var testMethodsArray:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.testMethodTF.textAlignment = .left
        self.testMethodTF.addPickerView(with: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWeld(weld:Weld, testMethods:[String:Int]) {
        
        if testMethodsArray.isEmpty{
            for (name, _) in testMethods{
                self.testMethodsArray.append(name)
            }
        }
        
        self.weldLbl.text = weld.number
        let state = weld.getWeldState(state: weld.state!).capitalized
        self.testMethodTF.text = weld.testMethod
        self.statusLbl.text = state
        self.statusLbl.isHidden = false
        if state == "Approved" {
//            weld.isChecked = true
            self.statusLbl.textColor = UIColor.muddyGreen
            self.testMethodTF.alpha = 0.5
        } else if state == "Fitting" {
            self.statusLbl.text = (weld.qARejectReason != nil && !(weld.qARejectReason?.isEmpty)!) ? "Rejected" : ""
            self.statusLbl.textColor = UIColor.scarlet
            self.testMethodTF.alpha = 0.5
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
    
    //MARK:- PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testMethodsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.testMethodTF.text = testMethodsArray[pickerView.selectedRow(inComponent: 0)]
        self.testMethodChangeddBlock!(self.testMethodTF.text!)
        return testMethodsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.testMethodTF.text = testMethodsArray[row]
        self.testMethodChangeddBlock!(self.testMethodTF.text!)
    }
}
