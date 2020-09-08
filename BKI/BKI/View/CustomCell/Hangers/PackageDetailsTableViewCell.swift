//
//  PackageDetailsTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class PackageDetailsTableViewCell: BaseCell {
    
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label1: UILabel!
    @IBOutlet var cutsDatalabel: UILabel!
    @IBOutlet var selectionButton: UIButton!
    @IBOutlet weak var selectionBtnWidth: NSLayoutConstraint!
    var optionSelected:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func designCellWith(bundleData:PackageBundleData,showCheckButton:Bool) {
        cutsDatalabel.text = bundleData.cuts.joined(separator: "\n\n")
        label2.text = "#No. Cuts : \(bundleData.numberOfCuts ?? 0)"
        label3.text = "#No. Rods : \(bundleData.numberOfRods ?? 0)"
        selectionButton.isHidden = !showCheckButton
        selectionBtnWidth.constant = showCheckButton ? 25.0 : 0.0
    }
    
    @IBAction func selectionOnClick(_ sender: Any) {
        self.optionSelected!()
    }
}
