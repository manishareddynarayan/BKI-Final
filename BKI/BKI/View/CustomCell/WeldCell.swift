//
//  WeldCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldCell: UITableViewCell, UITextFieldDelegate,Reusable
{
    //MARK:- IBOutlets
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var gasIdDropDown: UITextField!
    @IBOutlet weak var gasIdTF: AUTextField!
    @IBOutlet weak var gasIdDropDownBtn: UIButton!
    @IBOutlet weak var statusTF: AUTextField!
    
    //MARK:- Properties
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:WeldCell.self), bundle: nil)
    }
    var markAsCompletedBlock:(() -> Void)?
    var viewComments:(() -> Void)?
    var statusChangeddBlock:(() -> Void)?
    var isChecked = false
    var selectionChangedBlock:((_ isChecked:Bool) -> Void)?
    let arr = [["Type":"Rolled","Value":1],["Type":"Position","Value":2],["Type":"Orbital","Value":3]]
    let gasIdOptions:[String] = ["N/A"]
    
    //MARK:- UITableViewCell default methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.checkBtn.isHidden = true
        self.statusTF.isHidden = true
        self.statusTF.textAlignment = .left
        self.statusTF.addPickerView(with: self)
        self.gasIdDropDown.addPickerView(with: self)
        self.gasIdTF.initToolBar()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    //MARK:- Button Action methods
    @IBAction func onSelectWeld(_ sender: Any)
    {
        self.isChecked = !self.isChecked
        self.setImageForCheckBtn()
        self.selectionChangedBlock!(self.isChecked)
    }
    
    @IBAction func markAction(_ sender: Any)
    {
        self.markAsCompletedBlock!()
    }
    
    @IBAction func viewComments(_ sender: Any)
    {
        self.viewComments!()
    }
    
    @IBAction func gasIdDropDown(_ sender: Any)
    {
        self.gasIdDropDown.becomeFirstResponder()
    }
}
//MARK:- Private methods
extension  WeldCell
{
    private func setImageForCheckBtn()
    {
        let image = self.isChecked ? "Check" : "unCheck"
        checkBtn.setImage(UIImage.init(named: image), for: .normal)
    }
    
    func configureWeldCell(weld:Weld)
    {
        self.nameLbl.text = weld.number
        self.statusTF.text = (weld.weldType != nil) ? weld.weldType : ""
        self.isChecked = weld.isChecked
        self.gasIdTF.text = weld.gasId != nil ? weld.gasId : ""
        self.setImageForCheckBtn()
    }
}
//MARK:- UIPickerViewDataSource methods
extension WeldCell: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        let noOfRows = gasIdDropDown.isFirstResponder ? gasIdOptions.count : arr.count
        return noOfRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if gasIdDropDown.isFirstResponder
        {
            gasIdTF.text = gasIdOptions[pickerView.selectedRow(inComponent: 0)]
            return gasIdOptions[row]
        }
        else
        {
            self.completeBtn.isEnabled = true
            statusTF.text = arr[0]["Type"] as? String
            self.statusChangeddBlock!()
            let statusDict = arr[row]
            return statusDict["Type"] as? String
        }
    }
}
//MARK:- UIPickerViewDelegate methods
extension WeldCell:UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if gasIdDropDown.isFirstResponder
        {
            gasIdTF.text = gasIdOptions[row]
        }
        else
        {
            let statusDict = arr[row]
            guard let type = statusDict["Type"] as? String else
            {
                return
            }
            self.statusTF.text = type
            self.statusChangeddBlock!()
        }
    }
}
