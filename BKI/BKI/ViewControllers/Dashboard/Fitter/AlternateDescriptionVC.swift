//
//  AlternateDescriptionVC.swift
//  BKI
//
//  Created by Anchal Kumar Gupta on 06/03/19.
//  Copyright © 2019 srachha. All rights reserved.
//

import UIKit

class AlternateDescriptionVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var cell:AlternateDescriptionCell!
    var altData = [AlternateDescription()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AlternateDescriptionCell", bundle: nil), forCellReuseIdentifier: "alternateDescriptionCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        noDataLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
     }
    
    @IBAction func backBtn(_ sender: Any) {
        self.backButtonAction(sender: sender as AnyObject)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return altData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "alternateDescriptionCell") as? AlternateDescriptionCell
        cell.setCell(data: altData[indexPath.row])
        return cell
    }
}
