//
//  LoadCell.swift
//  BKI
//
//  Created by srachha on 01/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoadCell: BaseCell,Reusable
{
    //MARK:- IBOutlets
    @IBOutlet weak var viewDrawingBtn: UIButton!
    @IBOutlet weak var spoolLbl: UILabel!
    //MARK:- Properties
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:LoadCell.self), bundle: nil)
    }
    var viewDrawingBlock:(() -> Void)?
    
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
    @IBAction func viewDrawing(_ sender: Any)
    {
        self.viewDrawingBlock!()
    }
}
