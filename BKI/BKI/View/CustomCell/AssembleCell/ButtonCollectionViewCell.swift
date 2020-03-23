//
//  ButtonCollectionViewCell.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell,Reusable
{
    @IBOutlet weak var selectionButton: UIButton!
    
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:ButtonCollectionViewCell.self), bundle: nil)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
