//
//  AssembleTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 24/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class AssembleTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var upperView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func animate()
    {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
