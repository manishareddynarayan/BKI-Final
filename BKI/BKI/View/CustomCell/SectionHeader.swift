//
//  SectionHeader.swift
//  Emod-iOS
//
//  Created by Narayan Manisha on 18/03/20.
//  Copyright © 2020 Build Safely. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    static let reuseIdentifier = "SectionHeader"

    static var nib: UINib?
       {
           return UINib(nibName: String(describing:SectionHeader.self), bundle: nil)
       }
    override func awakeFromNib()
       {
           super.awakeFromNib()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
