//
//  PackageTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class StrutPackageTableViewCell: BaseCell {

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
    
    @IBAction func viewButtonOnClick(_ sender: Any) {
        self.viewDetails!()
    }
}
