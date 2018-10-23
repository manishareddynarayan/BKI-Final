//
//  InspectionVC.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var actionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "InspectionCell", bundle: nil), forCellReuseIdentifier: "inspectionCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.showActionButtons()
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
    }
    
    func getSelectedWeldIds() -> [Int] {
        let weldIds = self.spool?.welds.filter({ (weld) -> Bool in
            return weld.isChecked
        }).map({ (weld) -> Int in
            weld.id!
        })
        return weldIds!
    }
    
    func showActionButtons() {
        let isHidden = self.getSelectedWeldIds().count > 0 ? false : true
        self.actionView.isHidden = isHidden
    }
    
    @IBAction func approveWeldsAction(_ sender: Any) {
        self.updateWeldsWith("complete")
    }
    
    @IBAction func rejectWeldsAction(_ sender: Any) {
        self.updateWeldsWith("reject")
    }
    
    func updateWeldsWith(_ status:String) {
        
        MBProgressHUD.showHud(view: self.view)
        let weldIds = self.getSelectedWeldIds()
        let weldParams = ["weld_ids":weldIds as Any,"event":status] as [String : Any]
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)/welds/modify_state", methodType: "PUT", parameters: ["weld":weldParams as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                let welds = responseData["welds"] as? [[String:AnyObject]]
                self.spool?.saveWelds(welds: welds!)
                MBProgressHUD.hideHud(view: self.view)
            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.spool?.welds.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inspectionCell") as? InspectionCell
        let weld = self.spool?.welds[indexPath.row]
        cell?.configureWeld(weld: weld!)
        cell?.selectionChangeddBlock = { (isChecked) in
            weld?.isChecked = isChecked
            tableView.reloadData()
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weld = self.spool?.welds[indexPath.row]
        weld?.isChecked = !(weld?.isChecked)!
        tableView.reloadData()
        self.showActionButtons()
    }

}
