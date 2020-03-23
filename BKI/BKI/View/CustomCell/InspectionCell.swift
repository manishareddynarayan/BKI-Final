//
//  InspectionCell.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionCell: BaseCell,Reusable, UITextFieldDelegate
{
    //MARK:- IBOutlets
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var weldLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var testMethodTF: AUTextField!
    
    //MARK:- Properties
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:InspectionCell.self), bundle: nil)
    }
    var isChecked = false
    var testMethodsArray:[String] = []
    var selectionChangeddBlock:((_ isChecked:Bool) -> Void)?
    var testMethodChangeddBlock:((_ testMethod:String) -> Void)?
    //MARK:- Cell default Methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.testMethodTF.textAlignment = .left
        self.testMethodTF.addPickerView(with: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    //MARK:- IBAction
    @IBAction func checkMarkAction(_ sender: Any)
    {
        self.isChecked = !self.isChecked
        self.setImageForCheckBtn()
        self.selectionChangeddBlock!(self.isChecked)
    }
}
//MARK:- Private Methods
extension InspectionCell
{
    func configureWeld(weld:Weld, testMethods:[String:Int])
    {
        if testMethodsArray.isEmpty
        {
            for (name, _) in testMethods
            {
                self.testMethodsArray.append(name)
            }
        }
        
        self.weldLbl.text = weld.number
        let state = weld.getWeldState(state: weld.state!).capitalized
        self.testMethodTF.text = weld.testMethod
        self.statusLbl.text = state
        self.statusLbl.isHidden = false
        if state == "Approved"
        {
            //            weld.isChecked = true
            self.statusLbl.textColor = UIColor.muddyGreen
            self.testMethodTF.alpha = 0.5
        }
        else if state == "Fitting"
        {
            self.statusLbl.text = (weld.qARejectReason != nil && !(weld.qARejectReason?.isEmpty)!) ? "Rejected" : ""
            self.statusLbl.textColor = UIColor.scarlet
            self.testMethodTF.alpha = 0.5
        }
        else
        {
            self.statusLbl.isHidden = true
        }
        self.isChecked = weld.isChecked
        self.setImageForCheckBtn()
    }
    private func setImageForCheckBtn()
    {
        let image = self.isChecked ? "Check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
    }
}
//MARK:- PickerView
extension InspectionCell : UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return testMethodsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.testMethodTF.text = testMethodsArray[pickerView.selectedRow(inComponent: 0)]
        self.testMethodChangeddBlock!(self.testMethodTF.text!)
        return testMethodsArray[row]
    }
}
//MARK:- PickerView
extension InspectionCell : UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.testMethodTF.text = testMethodsArray[row]
        self.testMethodChangeddBlock!(self.testMethodTF.text!)
    }
}
