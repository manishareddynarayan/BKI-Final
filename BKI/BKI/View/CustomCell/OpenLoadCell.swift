//
//  OpenLoadCell.swift
//  BKI
//
//  Created by srachha on 01/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class OpenLoadCell: BaseCell,Reusable
{
    @IBOutlet weak var loadLbl: UILabel!
    //MARK:- Properties
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:OpenLoadCell.self), bundle: nil)
    }
    var loadEditBlock:(() -> Void)?
    
    //MARK:- Cell Default methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    //MARK:- IBAction methods
    @IBAction func editAction(_ sender: Any)
    {
        self.loadEditBlock!()
    }
}
