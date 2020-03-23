//
//  LabelCollectionViewCell.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell,Reusable
{
    @IBOutlet weak var nameLabel: UILabel!
       
       static var nib: UINib?
       {
           return UINib(nibName: String(describing:LabelCollectionViewCell.self), bundle: nil)
       }

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

}
