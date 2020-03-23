//
//  AssembleTableViewCell.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class AssembleTableViewCell: BaseCell,Reusable
{
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:AssembleTableViewCell.self), bundle: nil)
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
