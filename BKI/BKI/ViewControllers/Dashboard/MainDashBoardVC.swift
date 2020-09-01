//
//  MainDashBoardVC.swift
//  BKI
//
//  Created by srachha on 19/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class MainDashBoardVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var roleArr = ["Fit-Up","Weld","Shipping","Hangers"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        
        if BKIModel.userRole() == "qa" {
            self.roleArr.removeAll()
            self.roleArr.append("QA")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if self.scanCode != nil && self.role != 3{
            // call API and move to hangers dashboard
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.logoutUser()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DashboardSegue" {
            guard let vc = segue.destination as? DashBoardVC else {
                
                return
            }
            vc.role = BKIModel.userRole() == "qa" ?  4 : ((sender as? IndexPath)?.row)! + 1
        }
    }
    func getPackageDetails() {
        if self.scanItem != "Hanger" {
            self.showFailureAlert(with:"You have not a scanned a hanger, please check.")
            return
        }
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("hangers/\(self.scanCode!)/scan", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            var hanger:Hanger?
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
            hanger = Hanger.init(info: responseData)
                if hanger?.hangerState == "procure" || hanger?.hangerState == "receive" {
                    self.showFailureAlert(with: "Kindly complete the procurement process for this hanger.")
                } else {
                    guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "PackageViewController", storyBoard: "Hangers") as? PackageViewController else {
                        return
                    }
                    vc.hanger = hanger
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
                
            }
        }
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as? DashBoardCell
        cell?.titleLbl.text = roleArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 3 {
            self.showScanner()
            return
        }
        self.performSegue(withIdentifier: "DashboardSegue", sender: indexPath)
    }
}
extension MainDashBoardVC : ScannerDelegate{
    func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?)
    {
        self.setScanCode(data: data)
        if self.scanCode != nil && !(self.scanCode?.isEmpty ?? true){
            getPackageDetails()
        }
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error, from connection: AVCaptureConnection) {
        self.setScanCode(data: nil)
    }
}
