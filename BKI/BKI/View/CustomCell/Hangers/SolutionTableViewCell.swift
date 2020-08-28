//
//  SolutionTableViewCell.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class SolutionTableViewCell: BaseCell {
    @IBOutlet var cutsCountLabel: UILabel!
    @IBOutlet var wastageCountLabel: UILabel!
    @IBOutlet var rodsCountLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bundlesCountLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    var viewDetails:(() -> Void)?
    var chooseSolution:(() -> Void)?

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
    func prepareSolutionCellWith(solution:Solution,showChooseOption:Bool) {
        titleLabel.text = solution.name
        wastageCountLabel.text = solution.totalWastage  == nil ? "0" : solution.totalWastage
        rodsCountLabel.text = solution.numberOfRods == nil ? "0" : solution.numberOfRods
        bundlesCountLabel.text = solution.numberOfBundles == nil ? "0" : solution.numberOfBundles
        cutsCountLabel.text = solution.totalCuts == nil ? "0" : solution.totalCuts
        chooseButton.isHidden = !showChooseOption
    }
    
    @IBAction func viewOnClick(_ sender: Any) {
        self.viewDetails!()
    }
    
    @IBAction func chooseOnClick(_ sender: Any) {
        self.chooseSolution!()
    }
}
