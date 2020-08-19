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
    @IBOutlet var label1: UILabel!
    @IBOutlet var cutsDatalabel: UILabel!
    @IBOutlet var descriptionlabel: UILabel!
    @IBOutlet var selectionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectionOnClick(_ sender: Any) {
    }
}
