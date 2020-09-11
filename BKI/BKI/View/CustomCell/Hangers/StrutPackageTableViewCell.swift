//
//  PackageTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class StrutPackageTableViewCell: BaseCell {

    @IBOutlet weak var doneLabelView: UIView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
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
        self.sizeLabel.text = cuttingStat.size
        self.descriptionLabel.text = cuttingStat.desc
        self.doneLabelView.isHidden = !cuttingStat.bundlesCompleted
    }
    
    @IBAction func viewButtonOnClick(_ sender: Any) {
        self.viewDetails!()
    }
}
