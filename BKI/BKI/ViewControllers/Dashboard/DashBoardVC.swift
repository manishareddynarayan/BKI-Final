//
//  DashBoardVC.swift
//  BKI
//
//  Created by srachha on 19/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class DashBoardVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,ScannerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var menuItems: [[String:String]]!
    var shouldChangeState = false
    var altData = [AlternateDescription()]
    var scanned:Bool = false
   
    @IBOutlet weak var spoolLbl: UILabel!
    @IBOutlet weak var alternateDescriptionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuItems = User.shared.getUserMenuItems(with: self.role)
        tableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        
       alternateDescriptionBtn.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.scanCode = "7"
        if self.scanCode != nil && self.role != 3{
            self.getSpoolDetails()
        }
        
        if let spool = self.spool{
            if spool.lastFittingCompletion && !checkHeatNumbers() && self.role == 1{
                alertVC.presentAlertWithTitleAndMessage(title: "Warning", message: "Please enter heat numbers to move the spool to next state", controller: self)
                self.spool?.lastFittingCompletion = false
            }
        }
    }
    
    
    @IBAction func alternateDescriptionBtn(_ sender: Any) {
        self.performSegue(withIdentifier: ALTERNATEDESCRIPTIONSEGUE, sender: self)
    }
    
//    func checkWeldStatus() -> Bool{
//        if let spool = self.spool{
//            for weld in spool.welds{
//                if weld.state == WeldState.fitting{
//                    return false
//                }
//            }
//        }
//        return true
//    }
//
//    func checkHeatNumbers() -> Bool{
//        if let spool = self.spool{
//            for component in spool.components{
//                if component.heatNumber == ""{
//                    return false
//                }
//            }
//        }
//        return true
//    }
    
 
    func loadScanData(data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            self.setScanCode(data: nil)
            self.spoolLbl.text = self.spool?.code != nil ? spool?.code! : ""
            self.tableView.reloadData()
            return
        }
        self.setScanCode(data: data)
       // self.getSpoolDetails()
    }
    
    func getSpoolDetails() {
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(self.scanCode!)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                MBProgressHUD.hideHud(view: self.view)
                self.spool = Spool.init(info: responseData)
                BKIModel.setSpoolNumebr(number: self.spool?.code!)
                self.spoolLbl.text = self.spool?.code!
                if self.shouldChangeState {
                    self.tableView.reloadData()
                    self.shouldChangeState = false
                    return
                }
                if self.role == 1 {
                    self.getAlternateDescriptionData()
                }

//                if self.spool?.status == "On Hold" {
//                    self.showFailureAlert(with: "The Spool is on hold and hence no operation can be performed on it.")
//                }
//                    else if self.role == 2 && self.spool?.state != WeldState.welding {
//                    self.showFailureAlert(with: "You can access spools which are in state of welding.")
//                }
//                else  if (self.role == 1 && self.spool?.state != WeldState.fitting) {
//                    self.showFailureAlert(with: "You can access spools which are in state of fitting.")
//                }
//                else if (self.role == 4 && self.spool?.state != WeldState.qa)  {
//                    self.showFailureAlert(with: "You can access spools which are in state of QA.")
//                }
                
                if !self.checkHeatNumbers() && !self.checkFittingWeldStatus() && self.scanned{
                    self.alertVC.presentAlertWithTitleAndMessage(title: "Warning", message: "Please enter heat numbers to move the spool to next state", controller: self)
                }
                self.scanned = false
                
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)

//                if self.shouldChangeState {
//                    self.spool = nil
//                    self.tableView.reloadData()
//                    self.shouldChangeState = false
//                    return
//                }
                if error?.code == 403 {
                    self.httpWrapper.performAPIRequest("spools/\((self.scanCode)!)/current_stage", methodType: "GET", parameters: nil, successBlock: { (response) in
                        DispatchQueue.main.async {
                            print(response)
                            let status = response["current_state"] as! String
                            self.showFailureAlert(with: "Sorry! You cannot access this Spool as it is in \((status)) stage")
                            self.spool = nil
                            self.tableView.reloadData()
                        }
                    }, failBlock: { (error) in
                        print(error)
                    })
                    return
                }
                self.spool = nil
                self.showFailureAlert(with: (error?.localizedDescription)!)
                self.tableView.reloadData()
            }
        }
    }
    
    func getAlternateDescriptionData(){
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(String(describing: self.spool!.id!))/spool_grouped_components", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.altData.removeAll()
                for (key,value) in responseData{
                    if key != "Pipe"{
                        for i in 0...(responseData[key]!.count! - 1){
                            let valueDict = ((value as? NSArray)![i] as? [String:AnyObject])!
                            let alternateDescription = AlternateDescription.init(key: key,values: valueDict)
                            if alternateDescription.notes != "-" || alternateDescription.altDescription != "-"{
                                self.altData.append(alternateDescription)
                            }
                        }
                    }
                }
                MBProgressHUD.hideHud(view: self.view)
                self.tableView.reloadData()
                if self.altData.count == 0{
                    self.alternateDescriptionBtn.isHidden = true
                }else{
                    self.alternateDescriptionBtn.isHidden = false
                }
            }
        }) { (error) in
            MBProgressHUD.hideHud(view: self.view)
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.backButtonAction(sender: sender as AnyObject)
    }
    
    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == ALTERNATEDESCRIPTIONSEGUE{
            let alternateDescriptionVC = segue.destination as? AlternateDescriptionVC
            alternateDescriptionVC?.altData = self.altData

        }
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as? DashBoardCell
        let menu = self.menuItems[indexPath.row]
        cell?.titleLbl.text = menu["Name"]

        if spool == nil {
            if self.role == 3 {
                cell?.enable(enable: true)
            }
            else if self.menuItems.count - 1 == indexPath.row {
                cell?.enable(enable: true)
            } else {
                cell?.enable(enable: false)
            }
            return cell!
        }
//        if self.role == 1 && self.spool?.state == WeldState.fitting && self.spool?.status != "On Hold" {
//            cell?.enable(enable: true)
//        } else if self.role == 2 && self.spool?.state == WeldState.welding && self.spool?.status != "On Hold" {
//            cell?.enable(enable: true)
//        }
//        else if self.role == 4 && self.spool?.state == WeldState.qa && self.spool?.status != "On Hold" {
//            cell?.enable(enable: true)
//        }
//        else {
//            cell?.enable(enable: false)
//        }
//
//        if indexPath.row == self.menuItems.count - 1 || self.role == 3 && self.spool?.status != "On Hold" {
//            cell?.enable(enable: true)
//        }
        
        cell?.enable(enable: true)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        guard indexPath.row == self.menuItems.count - 1 && self.role != 3   else {
            let menu = self.menuItems[indexPath.row]
            guard let vc = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? BaseViewController else {
                guard let vc1 = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? FitterPartTVC else {
                    guard let vc2 = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? WeldStatusVC else {
                        return
                    }
                    vc2.role = self.role
                    vc2.spool = self.spool
                    self.navigationController?.pushViewController(vc2, animated: true)
                    return
                }
                vc1.role = self.role
                vc1.spool = self.spool
                self.navigationController?.pushViewController(vc1, animated: true)
                return
            }
            vc.spool = self.spool
            vc.role = self.role
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.showScanner()
    }
    
    //MARK: Scan Delegate Methods
    func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?)
    {
        self.loadScanData(data: data)
        scanned = true
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error, from connection: AVCaptureConnection) {
        self.loadScanData(data: nil)
    }

}
