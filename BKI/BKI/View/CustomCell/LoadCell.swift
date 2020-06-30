//
//  LoadCell.swift
//  BKI
//
//  Created by srachha on 01/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoadCell: BaseCell {

    var viewDrawingBlock:(() -> Void)?
    var deleteSpoolBlock:(() -> Void)?
    var viewISODrawingBlock:(() -> Void)?

    @IBOutlet weak var viewDrawingBtn: UIButton!
    @IBOutlet weak var spoolLbl: UILabel!
    @IBOutlet weak var deleteSpoolButton: UIButton!
    @IBOutlet weak var isoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func viewDrawing(_ sender: Any) {
        self.viewDrawingBlock!()
    }
    @IBAction func didTapDeleteSpoolFromLoad(_ sender: UIButton)
    {
        self.deleteSpoolBlock!()
    }
    
    @IBAction func didTapISODrawing(_ sender: UIButton)
    {
        self.viewISODrawingBlock!()
    }
}
