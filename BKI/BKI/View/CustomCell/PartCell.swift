//
//  PartCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class PartCell: BaseCell, UITextFieldDelegate,TextInputDelegate {

    @IBOutlet weak var heatLbl: UILabel!
    @IBOutlet weak var heatTF: AUTextField!
    var part:Part!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.heatTF.textAlignment = .left
        // Initialization code
    }

    func configureCell(part:Part, isNext:Bool, isPrev:Bool) {
        self.part = part
        self.heatTF.tag = self.indexPath.row
        self.heatTF.textAlignment = .left
        self.heatLbl.text = self.part.name!
        self.heatTF.text = self.part.heatNumber
        self.heatTF.designToolBarWithNext(isNext: isNext, withPrev: isPrev, delegate: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        let isFound = string.containsSpecialCharacters()
        return !isFound
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.part.heatNumber = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
