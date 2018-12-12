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
   
    @IBOutlet weak var spoolLbl: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuItems = User.shared.getUserMenuItems(with: self.role)
        tableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
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
    }
    
    func loadScanData(data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            self.setScanCode(data: nil)
            self.spoolLbl.text = ""
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
                if self.role == 2 && self.spool?.state != WeldState.welding {
                    self.showFailureAlert(with: "You can access spools which are in state of welding.")
                }
                else  if (self.role == 1 && self.spool?.state != WeldState.fitting) {
                    self.showFailureAlert(with: "You can access spools which are in state of fitting.")
                }
                else if (self.role == 4 && self.spool?.state != WeldState.qa)  {
                    self.showFailureAlert(with: "You can access spools which are in state of QA.")
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                
                if self.shouldChangeState {
                    self.spool = nil
                    self.tableView.reloadData()
                    self.shouldChangeState = false
                    MBProgressHUD.hideHud(view: self.view)
                    return
                }
                if error?.code == 403 {
                    self.httpWrapper.performAPIRequest("spools/\((self.scanCode)!)/current_stage", methodType: "GET", parameters: nil, successBlock: { (response) in
                        DispatchQueue.main.async {
                            print(response)
                            let status = response["current_state"] as! String
                            self.showFailureAlert(with: "Sorry! You cannot access this Spool as it is in \((status)) stage")
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
    
    @IBAction func backAction(_ sender: Any) {
        self.backButtonAction(sender: sender as AnyObject)
    }
    
    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
        if self.role == 1 && self.spool?.state == WeldState.fitting {
            cell?.enable(enable: true)
        } else if self.role == 2 && self.spool?.state == WeldState.welding {
            cell?.enable(enable: true)
        } 
        else if self.role == 4 && self.spool?.state == WeldState.qa {
            cell?.enable(enable: true)
        }
        else {
            cell?.enable(enable: false)
        }
        
        if indexPath.row == self.menuItems.count - 1 || self.role == 3 {
            cell?.enable(enable: true)
        }
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        guard indexPath.row == self.menuItems.count - 1 && self.role != 3   else {
            let menu = self.menuItems[indexPath.row]
            guard let vc = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? BaseViewController else {
                guard let vc1 = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? FitterPartTVC else {
                    guard let vc2 = self.getViewControllerWithIdentifier(identifier: menu["Child"]!) as? WeldStatusTVC else {
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
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error, from connection: AVCaptureConnection) {
        self.loadScanData(data: nil)
    }

}
