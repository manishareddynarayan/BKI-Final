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
            self.getScannedItemDetails()
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
    
    func saveHeatNumbersforNoWelds(){
        var components = [[String:AnyObject]]()
        for component in (self.spool?.components)! {
            let dict = ["id":component.id!, "heat_number": component.heatNumber] as [String : Any]
            components.append(dict as [String : AnyObject])
        }
        let spoolParams = ["components_attributes":components]
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)", methodType: "PUT", parameters: ["spool":spoolParams as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
            }
        }) { (error) in
            self.showFailureAlert(with:(error?.localizedDescription)! )
        }
    }
    
    func getEvolveDetails() {
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("evolve_fabrications/\(self.scanCode!)/scan", methodType: "GET", parameters: nil) { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                let evolveItem = Evolve.init(info: responseData)
                if (!(evolveItem.isInFabrication)! && evolveItem.evolveState != "cutting") {
                    self.showFailureAlert(with:"This is not in fabrication" )
                    return
                }
                self.evolve = evolveItem
                self.tableView.reloadData()
                print(responseData)
            }
        } failBlock: { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with:(error?.localizedDescription)! )
            }
        }
    }
    
    func getSpoolDetails() {
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(self.scanCode!)?scan=true", methodType: "GET", parameters: nil, successBlock: { (responseData) in
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
                
                if self.spool?.status == "On Hold" {
                    self.showFailureAlert(with: "The Spool is on hold and hence no operation can be performed on it.")
                }
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
                
                if self.spool?.welds.count == 0{
                    if self.checkHeatNumbers(){
                        if self.spool?.state != WeldState.inShipping && self.spool?.state != WeldState.readyToShip && self.spool?.state != WeldState.shipped{
                            //Calling API to move spool to shipping
                            self.saveHeatNumbersforNoWelds()
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
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
    
    func getScannedItemDetails() {
        if self.scanCode != nil && (self.scanCode?.isEmpty ?? true) {
            return
        }
        if self.scanItem == "Hanger" {
            self.showFailureAlert(with:"You have scanned a hanger, please check.")
            return
        } else if self.scanItem == "EvolveFabrication" {
            if self.role == 2 {
                self.showFailureAlert(with:"You have scanned a evolve, please check.")
                return
            }
            self.spool = nil
            getEvolveDetails()
            return
        }
        self.evolve = nil
        getSpoolDetails()
    }
    
    func getAlternateDescriptionData(){
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(String(describing: self.spool!.id!))/spool_grouped_components", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.altData.removeAll()
                for (key,value) in responseData{
                    if key != "Pipe"{
                        if responseData[key]!.count! > 0{
                            for i in 0...(responseData[key]!.count! - 1){
                                let valueDict = ((value as? NSArray)![i] as? [String:AnyObject])!
                                let alternateDescription = AlternateDescription.init(key: key,values: valueDict)
                                if alternateDescription.notes != "-" || alternateDescription.altDescription != "-"{
                                    self.altData.append(alternateDescription)
                                }
                            }
                        }
                    }
                }
                MBProgressHUD.hideHud(view: self.view)
                self.tableView.reloadData()
                if self.altData.isEmpty{
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
        
        if  (spool == nil && evolve == nil) {
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
        
        if spool != nil {
            if self.spool?.status == "On Hold" || (self.spool?.isArchivedOrRejected)!{
                if indexPath.row == 3 && self.role == 1{
                    cell?.enable(enable: true)
                }else if indexPath.row == 1 && self.role == 2{
                    cell?.enable(enable: true)
                }else if indexPath.row == 2 && self.role == 4{
                    cell?.enable(enable: true)
                }else if indexPath.row == self.menuItems.count - 1{
                    cell?.enable(enable: true)
                }else{
                    cell?.enable(enable: false)
                }
            }else{
              if indexPath.row != 2 && self.role != 4{
                    cell?.enable(enable: true)
                } else if indexPath.row != 1 && self.role == 4 {
                    cell?.enable(enable: true)
                } else {
                    cell?.enable(enable: false)
                }
            }
            // disbaling cell when ISO Drwaing url is nil,which one we are showing in web view.
            if ((indexPath.row == self.menuItems.count - 2) && (self.spool?.isoDrawingURL == nil) && (self.menuItems[indexPath.row]["Child"] == "DrawingVC"))
            {
                cell?.enable(enable: false)
            }
        } else {
            if ((self.evolve?.isArchivedOrRejected) != nil) && self.evolve?.evolveState == "cutting"{
                if indexPath.row == 3 && self.role == 1{
                    cell?.enable(enable: true)
                }else if indexPath.row == self.menuItems.count - 1{
                    cell?.enable(enable: true)
                } else if indexPath.row == 2 && self.role == 4{
                    cell?.enable(enable: true)
                } else{
                    cell?.enable(enable: false)
                }
            }else{
                if self.role == 1 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == self.menuItems.count - 2) {
                    cell?.enable(enable: false)
                } else if self.role == 4 && (indexPath.row == 0 || indexPath.row == self.menuItems.count - 2){
                    cell?.enable(enable: false)
                } else {
                    cell?.enable(enable: true)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == self.menuItems.count - 1 && self.role != 3   else {
            let menu = self.menuItems[indexPath.row]
            guard let vc = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? DrawingVC else {
                guard let vc = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? BaseViewController else {
                    guard let vc1 = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? FitterPartTVC else {
                        return
                    }
                    vc1.role = self.role
                    vc1.spool = self.spool
                    self.navigationController?.pushViewController(vc1, animated: true)
                    return
                }
                vc.evolve = self.evolve
                vc.spool = self.spool
                vc.role = self.role
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            if spool != nil {
                vc.spool = self.spool
            } else {
                vc.evolve = self.evolve
            }
            vc.role = self.role
            
            vc.urltype = ((indexPath.row == self.menuItems.count - 2) ? .ISOURL : .pdfURL)
            if (indexPath.row == self.menuItems.count - 2) && ((spool?.isoDrawingURL) == nil)
            {
                self.alertVC.presentAlertWithMessage(message: "No ISO URL found", controller: self)
                return
            }
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
