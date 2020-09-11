//
//  RodPackageTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class RodPackageTableViewCell: BaseCell {

    @IBOutlet weak var doneLabelView: UIView!
    @IBOutlet var DescriptionLabel: UILabel!
    var viewDetails:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear


        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func designCellWith(cuttingStat:CuttingStat) {
        self.DescriptionLabel.text = cuttingStat.desc
        self.doneLabelView.isHidden = !cuttingStat.bundlesCompleted
    }

    @IBAction func showDetailsOnClick(_ sender: Any) {
        self.viewDetails!()
    }
}
