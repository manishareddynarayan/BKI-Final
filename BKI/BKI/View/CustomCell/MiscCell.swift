//
//  MiscCell.swift
//  BKI
//
//  Created by srachha on 11/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class MiscCell: BaseCell, UITextFieldDelegate, TextInputDelegate {
    @IBOutlet weak var qtyLbl: UILabel!
    
    @IBOutlet weak var qtyTF: AUTextField!
    @IBOutlet weak var decTF: AUTextField!
    
    var quantityCompletedBlock:((_ text:String) -> Void)?
    var descCompletionBlock:(() -> Void)?
    var descEnterBlock:(() -> Void)?
    var deleteMiscellaniousBlock:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.qtyTF.textAlignment = .left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(material:Material) {
        self.qtyTF.tag = self.indexPath.row
        self.qtyTF.textAlignment = .left
        self.qtyTF.text = "\(material.quantity)"
        self.decTF.textAlignment = .left
        self.decTF.text = material.desc
        self.decTF.tag = self.indexPath.row + 1
        self.qtyTF.designToolBarWithNext(isNext: true, withPrev: false, delegate: self)
        self.decTF.designToolBarWithNext(isNext: false, withPrev: true, delegate: self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == qtyTF {
            return true
        }
        self.descEnterBlock!()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == qtyTF {
            self.quantityCompletedBlock!(qtyTF.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text
        let idx = (textField.text?.index((textField.text?.startIndex)!, offsetBy: range.location))
        if  string.count > 0 {
            let char:Character = string[string.startIndex]
            text?.insert(char, at: idx!)
        }
        else {
            text?.remove(at: idx!)
        }
        let str = text
        if textField == qtyTF {
            self.quantityCompletedBlock!(str!)
        }
       
        return true
    }
    
    @IBAction func deleteMicillaniousAction(_ sender: Any) {
        self.deleteMiscellaniousBlock!()
    }
}
