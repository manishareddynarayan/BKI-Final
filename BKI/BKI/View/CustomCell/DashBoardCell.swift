//
//  DashBoardCell.swift
//  BKI
//
//  Created by srachha on 20/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class DashBoardCell: BaseCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.contentView.backgroundColor = UIColor.clear
        titleLbl.textColor = UIColor.brickRed
        titleLbl.font = UIFont.systemMedium17
        self.backgroundColor = UIColor.clear
        countLabel.layer.borderWidth = 1
        countLabel.layer.borderColor = UIColor.appRed.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func enable(enable:Bool) {
        self.isUserInteractionEnabled = enable
        self.container.alpha = enable ? 1.0 : 0.5
    }
    
    func configureDashBoardCell() -> Void {
        
    }
    
    @IBAction func detailArrowAction(_ sender: Any) {
        
    }
    
}
