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
        let frame = !((self.spool?.welds.isEmpty)!) ? CGRect.zero : self.headerView.frame
        self.headerView.frame = frame
        self.headerView.isHidden = !((self.spool?.welds.isEmpty)!)
        self.tableView.isHidden = (self.spool?.welds.isEmpty)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        rejectOptionsView.isHidden = self.viewState == DashBoardState.fitup ? true : false
        super.viewWillAppear(animated)
        self.showRejectButton(rejectBtn: rejectBtn)
        self.resetWeldStatus()
        rejectSpoolButtonState()
    }
    
    func rejectSpoolButtonState() {
        rejectSpoolBtn.isEnabled = !checkWeldingWeldStatus() ? false : true
        rejectSpoolBtn.alpha = !checkWeldingWeldStatus() ? 0.5 : 1
    }
    
    func updateWeldStatus(weld:Weld) {
        //weld qa complete verify  reject weld_type
        var event = "weld"
        var params = [String:AnyObject]()
        switch weld.state {
        case .fitting?:
            event = "weld"
            break
        case .welding?:
            event = "qa"
            if weld.weldType != nil {
                params["weld_type"] = weld.weldType as AnyObject
            }
            if let gasId = weld.gasId{
                params["backing_gas_id"] = gasId as AnyObject
            }
            break
        default:
            event = "complete"
            break
        }
//        params["event"] = event as AnyObject
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)/welds/\((weld.id)!)?event=\(event as AnyObject)", methodType: "PUT", parameters: ["weld":params] as [String:AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                MBProgressHUD.hideHud(view: self.view)
                weld.saveWeld(weldInfo: responseData)
                self.showRejectButton(rejectBtn: self.rejectBtn)
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
        
        if checkLastFitting(){
            self.spool?.lastFittingCompletion = true
        }
        if checkLastWelding(){
            self.rejectSpoolBtn.isEnabled = false
            self.rejectSpoolBtn.alpha = 0.5
        }
    }
    
    @IBAction func updateSpoolStatus(_ sender: Any) {
        let event = (self.spool?.state == .fitting) ? "fitted" : "welded"
        let params = ["event":event]
        // self.updateSpoolStateWith(spool: self.spool!, params: params as [String : AnyObject])
        self.updateSpoolStateWith(spool: self.spool!, params: params as [String : AnyObject], isSpoolUpdate: true, updateTableView: tableView)
    }
    
    @IBAction func rejectSpool(_ sender: Any) {
        shouldRejectWholeSpool = true
        rejectWelds(andUpdate: self.tableView, caller: "weld")
        
    }
    
    @IBAction func rejectWelds(_ sender: Any) {
        shouldRejectWholeSpool = false
        rejectWelds(andUpdate: self.tableView, caller: "weld")
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
        cell?.checkBtn.isHidden = viewState == DashBoardState.fitup ? true : false
        cell?.statusTF.isHidden = viewState == DashBoardState.fitup  ? true : false
        cell?.gasIdTF.isHidden = (viewState == DashBoardState.weld  && self.spool!.isStainlessSteel!) ? false : true
        cell?.gasIdDropDownBtn.isHidden = viewState == DashBoardState.weld  && self.spool!.isStainlessSteel! ? false:true
        
        cell?.commentsBtn.isHidden = (weld?.welderRejectReason == nil && weld?.qARejectReason == nil) ? true : false
        if  self.viewState == DashBoardState.fitup
        {
            cell?.completeBtn.setImage((weld?.state == WeldState.fitting) ? UIImage.init(named: "tickCircle") : UIImage.init(named: "tick"), for: .normal)
            cell?.completeBtn.isUserInteractionEnabled = weld?.state == WeldState.fitting ? true : false
        }
        else if self.viewState == DashBoardState.weld
        {
            cell?.completeBtn.setImage((weld?.state == WeldState.welding || weld?.state == WeldState.fitting) ? UIImage.init(named: "tickCircle") : UIImage.init(named: "tick"), for: .normal)
            let enable = weld?.state == WeldState.welding
            cell?.completeBtn.isEnabled = enable
            cell?.statusTF.isEnabled = enable
            cell?.checkBtn.isEnabled = enable
            cell?.gasIdDropDownBtn.isEnabled = enable
            cell?.gasIdTF.isEnabled = enable
            
            cell?.nameLbl.alpha = enable ? 1 : 0.5
            cell?.completeBtn.alpha = enable ? 1 : 0.5
            cell?.statusTF.alpha = enable ? 1 : 0.5
            cell?.gasIdDropDownBtn.alpha = enable ? 1 : 0.5
            cell?.gasIdTF.alpha = enable ? 1 : 0.5
        }
        
        cell!.markAsCompletedBlock = {
            weld?.gasId = !((cell?.gasIdTF.text!.isEmpty)!) ? cell?.gasIdTF.text : nil
            if (!((cell?.statusTF.text?.isEmpty)!) && !(self.spool!.isStainlessSteel!)) || (!((cell?.statusTF.text?.isEmpty)!) && !(cell?.gasIdTF.text!.isEmpty)!)  || self.viewState == DashBoardState.fitup
            {
                self.updateWeldStatus(weld: weld!)
                weld?.isChecked = false
            }else{
                self.showFailureAlert(with: "Please enter all the fields to complete the weld")
            }
            
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
