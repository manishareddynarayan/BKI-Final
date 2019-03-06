//
//  WeldStatusTVC.swift
//  BKI
//
//  Created by srachha on 08/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class WeldStatusVC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    var weldsArr = [Weld]()
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rejectOptionsView: UIView!
    @IBOutlet weak var rejectSpoolBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var alertMessageLabel2: UILabel!
    @IBOutlet weak var alertTitle2: UILabel!
    @IBOutlet weak var alertMessageLabel1: UILabel!
    @IBOutlet weak var alertTitle1: UILabel!
    @IBOutlet weak var alertViewOkBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "WeldCell", bundle: nil), forCellReuseIdentifier: "weldCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
        self.hideNavigationController()
        let frame = (self.spool?.welds.count)! > 0 ? CGRect.zero : self.headerView.frame
        self.headerView.frame = frame
        self.headerView.isHidden = ((self.spool?.welds.count)! > 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        rejectOptionsView.isHidden = self.role == 1 ? true : false
        super.viewWillAppear(animated)
        self.showRejectButton(rejectBtn: rejectBtn)
        self.resetWeldStatus()
    }
    
    func updateWeldStatus(weld:Weld) {
        //weld qa complete verify  reject weld_type
        var event = "weld"
        var params = [String:AnyObject]()
        switch self.spool?.state {
        case .fitting?:
            event = "weld"
            break
        case .welding?:
            event = "qa"
            if weld.weldType != nil {
                params["weld_type"] = weld.weldType as AnyObject
            }
            break
        default:
            event = "complete"
            break
        }
        params["event"] = event as AnyObject
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)/welds/\((weld.id)!)", methodType: "PUT", parameters: ["weld":params as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                MBProgressHUD.hideHud(view: self.view)
                weld.saveWeld(weldInfo: responseData)
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    @IBAction func updateSpoolStatus(_ sender: Any) {
        let event = (self.spool?.state == .fitting) ? "fitted" : "welded"
        let params = ["event":event]
        // self.updateSpoolStateWith(spool: self.spool!, params: params as [String : AnyObject])
        self.updateSpoolStateWith(spool: self.spool!, params: params as [String : AnyObject], isSpoolUpdate: true)
    }
    
    @IBAction func rejectSpool(_ sender: Any) {
        shouldRejectWholeSpool = true
        rejectWelds()
    }
    
    @IBAction func rejectWelds(_ sender: Any) {
        shouldRejectWholeSpool = false
        rejectWelds()
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.spool?.welds.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weldCell", for: indexPath) as? WeldCell
        let weld = self.spool?.welds[indexPath.row]
        cell?.configureWeldCell(weld: weld!)
        cell?.checkBtn.isHidden = role == 1 ? true : false
        cell?.statusTF.isHidden = role == 1 ? true : false
        cell?.commentsBtn.isHidden = (weld?.welderRejectReason == nil && weld?.qARejectReason == nil) ? true : false
        if  self.role == 1 {
            cell?.completeBtn.setTitle(weld?.state == WeldState.fitting ? "Mark Complete" : "Completed", for: .normal)
            cell?.completeBtn.isUserInteractionEnabled = weld?.state == WeldState.fitting ? true : false
        } else if self.role == 2 {
            cell?.completeBtn.isEnabled = (cell?.statusTF.text?.count == 0) ? false : true
            cell?.completeBtn.setTitle(weld?.state == WeldState.welding ? "Complete" : "Completed", for: .normal)
            let enable = weld?.state == WeldState.welding  ? true : false
            cell?.completeBtn.isUserInteractionEnabled = enable
            cell?.statusTF.isUserInteractionEnabled = enable
        }
        cell!.markAsCompletedBlock = {
            self.updateWeldStatus(weld: weld!)
        }
        cell!.statusChangeddBlock = {
            weld?.weldType = cell?.statusTF.text!
        }
        cell?.viewComments = {
            if weld?.qARejectReason == nil || weld?.welderRejectReason == nil {
                let title = weld?.qARejectReason == nil ? "Welder Reason" : "QA Reason"
                let message = weld?.qARejectReason == nil ? weld?.welderRejectReason : weld?.qARejectReason
                self.alertVC.presentAlertWithTitleAndMessage(title: title, message: message!, controller: self)
            } else {
                self.setUpAlertView(weld: weld!)
            }
        }
        cell?.selectionChangedBlock = { (isChecked) in
            weld?.isChecked = isChecked
            tableView.reloadData()
            self.showRejectButton(rejectBtn: self.rejectBtn)
        }
        return cell!
    }
    
    func setUpAlertView(weld:Weld) {
        self.navigationController?.navigationBar.alpha = 0.6
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.baseView.isUserInteractionEnabled = false
        self.blurView.isHidden = false
        self.blurView.alpha = 0.4
        self.blurView.isUserInteractionEnabled = false
        self.alertView.isHidden = false
        self.alertTitle1.text = "Welder Reason"
        self.alertTitle2.text = "QA Reason"
        self.alertMessageLabel1.text = weld.welderRejectReason
        self.alertMessageLabel2.text = weld.qARejectReason
    }
    
    @IBAction func okOnClick(_ sender: Any) {
        alertView.isHidden = true
        self.baseView.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.alpha = 1
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.blurView.isHidden = true
    }
}

extension WeldStatusVC {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "dsjh"
    }
}
