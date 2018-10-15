//
//  WeldStatusTVC.swift
//  BKI
//
//  Created by srachha on 08/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldStatusTVC: BaseTableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var weldsArr = [Weld]()
    var spool:Spool?
    let httpWrapper = HTTPWrapper.sharedInstance
    var role:Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "WeldCell", bundle: nil), forCellReuseIdentifier: "weldCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
        self.hideNavigationController()
    }
    
    func updateWeldStatus(weld:Weld) {
        //weld qa complete reject weld_type
        var event = "weld"
        var params = [String:AnyObject]()
        switch self.role {
        case 1:
            event = "weld"
            break
        case 2:
            event = "qa"
            if weld.weldType != nil {
                params["weld_type"] = weld.weldType as AnyObject
            }
            break
        default:
            event = "complete"
            break
        }
        //let params = ["event":event]
        params["event"] = event as AnyObject
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)/welds/\((weld.id)!)", methodType: "PUT", parameters: ["weld":params as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                weld.saveWeld(weldInfo: responseData)
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.spool?.welds.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weldCell", for: indexPath) as? WeldCell
        let weld = self.spool?.welds[indexPath.row]
        cell?.configureWeldCell(weld: weld!)
        cell?.statusTF.isHidden = role == 1 ? true : false

        if  self.role == 1 {
            cell?.completeBtn.setTitle(weld?.state == WeldState.fitting ? "Mark Complete" : "Completed", for: .normal)
            cell?.completeBtn.isUserInteractionEnabled = weld?.state == WeldState.fitting ? true : false
        }
        else if self.role == 2 {
            cell?.completeBtn.setTitle(weld?.state == WeldState.welding ? "Complete" : "Completed", for: .normal)
            let enable = weld?.state == WeldState.welding ? true : false
            cell?.completeBtn.isUserInteractionEnabled = enable
            cell?.statusTF.isUserInteractionEnabled = enable
        }
        cell!.markAsCompletedBlock = {
            self.updateWeldStatus(weld: weld!)
        }
        cell!.statusChangeddBlock = {
            weld?.weldType = cell?.statusTF.text!
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

extension WeldStatusTVC {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        
    {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return "dsjh"
    }
    
}
