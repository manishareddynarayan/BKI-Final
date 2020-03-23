//
//  PartCell.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class PartCell: BaseCell,Reusable
{
    //MARK:- IBOutlets
    @IBOutlet weak var heatLbl: UILabel!
    @IBOutlet weak var heatTF: AUTextField!
    //MARK:- Properties
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:PartCell.self), bundle: nil)
    }
    var component:Component!
    var updatedHeatNumber:((_ component:Component) -> Void)?
    //MARK:- Cell default methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.heatTF.textAlignment = .left
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
//MARK:- Private methods
extension PartCell
{
    func configureCell(component:Component, isNext:Bool, isPrev:Bool, isLoaded:Bool)
    {
        self.component = component
        self.heatTF.tag = self.indexPath.row
        self.heatTF.textAlignment = .left
        self.heatLbl.text = self.component.part_number!
        self.heatTF.text = self.component.heatNumber
        self.heatTF.designToolBarWithNext(isNext: isNext, withPrev: isPrev, delegate: self)
        self.heatTF.isUserInteractionEnabled = !isLoaded
    }
    
    func getTextField() -> AUTextField
    {
        return self.heatTF
    }
}
//MARK: TextInputDelegate Methods
extension PartCell:TextInputDelegate
{
    
}
//MARK: TextField Delegate Methods
extension PartCell: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.component.heatNumber = textField.text!
        self.updatedHeatNumber!(self.component)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
