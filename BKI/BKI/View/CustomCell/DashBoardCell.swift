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
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.contentView.backgroundColor = UIColor.clear
        titleLbl.textColor = UIColor.brickRed
        titleLbl.font = UIFont.systemMedium17
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureDashBoardCell() -> Void {
        
    }
    
    
    @IBAction func detailArrowAction(_ sender: Any) {
        
        
    }
    
}
