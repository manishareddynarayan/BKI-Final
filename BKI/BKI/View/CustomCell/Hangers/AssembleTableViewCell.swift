//
//  AssembleTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 24/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class AssembleTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var rodSizeLabel: UILabel!
    @IBOutlet weak var rodWidthLabel: UILabel!
    @IBOutlet weak var rodLengthBLabel: UILabel!
    @IBOutlet weak var rodLengthALabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var sizeLAbel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var hangerNumber: UILabel!
    var optionSelected:(() -> Void)?
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
    func designCellWith(model:HangerAssembleItem) {
        rodSizeLabel.text = model.rodSize
        rodWidthLabel.text = model.rodWidth.isEmpty ? "-" : model.rodWidth
        rodLengthALabel.text = model.rodLengthA.isEmpty ? "-" : model.rodLengthA
        rodLengthBLabel.text = model.rodLengthB.isEmpty ? "-" : model.rodLengthB
        descriptionLabel.text = model.desc.isEmpty ? "-" : model.desc
        sizeLAbel.text = model.hangerSize.isEmpty ? "-" : model.hangerSize
        quantityLabel.text = model.quantity.isEmpty ? "-" : model.quantity
        hangerNumber.text = model.hangerNumber.isEmpty ? "-" : model.hangerNumber
    }
    @IBAction func chooseItem(_ sender: Any) {
        self.optionSelected!()
    }
}
