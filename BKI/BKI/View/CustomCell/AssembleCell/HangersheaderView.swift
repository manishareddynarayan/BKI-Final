//
//  HangersheaderView.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class HangersheaderView: UITableViewHeaderFooterView,Reusable
{
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    static var nib: UINib?
    {
        return UINib(nibName: String(describing:HangersheaderView.self), bundle: nil)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
