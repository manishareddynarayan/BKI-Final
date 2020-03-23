//
//  LabelTableViewCell.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class LabelTableViewCell: BaseCell,Reusable
{
    @IBOutlet weak var nameLabel: UILabel!
    
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:LabelTableViewCell.self), bundle: nil)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
