//
//  InspectionCell.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionCell: BaseCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var weldLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var IDTestMethodChangeddBlock:((_ testMethod:String) -> Void)?
    var ODTestMethodChangeddBlock:((_ testMethod:String) -> Void)?
    @IBOutlet weak var ODTestMethodTF: UITextField!
    @IBOutlet weak var IDTestMethodTF: UITextField!
    var isChecked = false
    var selectionChangeddBlock:((_ isChecked:Bool) -> Void)?
    var IDTestMethodsArray:[String] = []
    var ODTestMethodsArray:[String] = []
    var selectedTextField:UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.IDTestMethodTF.delegate = self
        self.ODTestMethodTF.delegate = self
        self.IDTestMethodTF.textAlignment = .left
        self.IDTestMethodTF.addPickerView(with: self)
        self.ODTestMethodTF.textAlignment = .left
        self.ODTestMethodTF.addPickerView(with: self)
        self.IDTestMethodTF.tintColor = .clear
        self.ODTestMethodTF.tintColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWeld(weld:Weld, IDTestMethods:[String:Int],ODTestMethods:[String:Int]) {
        
        if IDTestMethodsArray.isEmpty{
            for (name, _) in IDTestMethods{
                self.IDTestMethodsArray.append(name)
            }
        }
        if ODTestMethodsArray.isEmpty{
            for (name, _) in ODTestMethods{
                self.ODTestMethodsArray.append(name)
            }
        }
        self.weldLbl.text = weld.number
        let state = weld.getWeldState(state: weld.state!).capitalized
        self.IDTestMethodTF.text = weld.idTestMethod
        self.ODTestMethodTF.text = weld.odTestMethod
        statusImageView.isHidden = false
        if state == "Approved" {
//            weld.isChecked = true
            statusImageView.image = UIImage(named: "tick")
            self.IDTestMethodTF.alpha = 0.5
            self.ODTestMethodTF.alpha = 0.5
        } else if state == "Fitting" {
            statusImageView.image = (weld.qARejectReason != nil && !(weld.qARejectReason?.isEmpty)!) ? UIImage(named: "Rejected") : UIImage(named: "")
            self.IDTestMethodTF.alpha = 0.5
            self.ODTestMethodTF.alpha = 0.5
        }
        else {
            statusImageView.isHidden = true
        }
        self.isChecked = weld.isChecked
        self.setImageForCheckBtn()
    }
    
    @IBAction func checkMarkAction(_ sender: Any) {
        self.selectionChangeddBlock!(self.isChecked)
        self.isChecked = !self.isChecked
        self.setImageForCheckBtn()
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
        return selectedTextField == IDTestMethodTF ? IDTestMethodsArray.count : ODTestMethodsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedTextField == IDTestMethodTF {
        self.IDTestMethodTF.text = IDTestMethodsArray[pickerView.selectedRow(inComponent: 0)]
        self.IDTestMethodChangeddBlock!(self.IDTestMethodTF.text!)
        return IDTestMethodsArray[row]
        } else {
            self.ODTestMethodTF.text = ODTestMethodsArray[pickerView.selectedRow(inComponent: 0)]
            self.ODTestMethodChangeddBlock!(self.ODTestMethodTF.text!)
            return ODTestMethodsArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTextField == IDTestMethodTF {
        self.IDTestMethodTF.text = IDTestMethodsArray[row]
        self.IDTestMethodChangeddBlock!(self.IDTestMethodTF.text!)
        } else {
            self.ODTestMethodTF.text = ODTestMethodsArray[row]
            self.ODTestMethodChangeddBlock!(self.ODTestMethodTF.text!)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
}
