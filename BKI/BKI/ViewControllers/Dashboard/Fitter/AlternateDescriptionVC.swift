//
//  AlternateDescriptionVC.swift
//  BKI
//
//  Created by Anchal Kumar Gupta on 06/03/19.
//  Copyright © 2019 srachha. All rights reserved.
//

import UIKit

class AlternateDescriptionVC: BaseViewController
{
    //MARK:- IBOutlets
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Properties
    var altData = [AlternateDescription()]
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.registerReusableCell(AlternateDescriptionCell.self)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        noDataLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
     }
    //MARK:- IBAction
    @IBAction func backBtn(_ sender: Any)
    {
        self.backButtonAction(sender: sender as AnyObject)
    }
}
//MARK:- UITableViewDataSource methods
extension AlternateDescriptionVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return altData.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell:AlternateDescriptionCell = tableView.dequeueReusableCell(indexPath: indexPath) as AlternateDescriptionCell
         cell.setCell(data: altData[indexPath.row])
         return cell
     }
}
