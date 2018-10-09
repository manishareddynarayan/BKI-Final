//
//  NewLoadVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class NewLoadVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,ScannerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var spoolArr = [String]()
    @IBOutlet var saveBtn: UIBarButtonItem!
    @IBOutlet var scanBtn: UIBarButtonItem!
    var load:Load?
    var isEdit = false
    var scannedSpools = [Spool]()
    var newMaterials = [Material]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [saveBtn,scanBtn]
        tableView.register(UINib(nibName: "LoadCell", bundle: nil), forCellReuseIdentifier: "loadCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        load == nil ? self.createNewLoad() : self.getLoadDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewLoad() {
        self.httpWrapper.performAPIRequest("loads/", methodType: "POST",
        parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                if self.load == nil {
                    self.load = Load()
                }
                self.load!.saveLoad(loadInfo: responseData)
                self.navigationItem.title = "Load Number " + self.load!.number!
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    func getLoadDetails() {
        self.navigationItem.title = "Load Number " + self.load!.number!
        self.httpWrapper.performAPIRequest("loads/\(self.load!.id!)", methodType: "GET",
        parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.load!.saveLoad(loadInfo: responseData)
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func scanAction(_ sender: Any) {
        self.showScanner()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard self.scannedSpools.count > 0 || self.newMaterials.count > 0 else {
            self.alertVC.presentAlertWithMessage(message: "Please add new spool and materials", controller: self)
            return
        }
        var loadParams:[String:AnyObject] = ["id":self.load!.id! as AnyObject]
        
        if self.scannedSpools.count > 0 {
            var spoolIds = [String]()
            for spool in scannedSpools {
                //spoolIds.append("\(spool.id!)")
                spoolIds.append("1")
            }
            loadParams["spool_id"] =  spoolIds as AnyObject
        }
        
        self.httpWrapper.performAPIRequest("loads/\(self.load!.id!)", methodType: "PUT",
        parameters: ["load":loadParams as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.load!.saveLoad(loadInfo: responseData)
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func submitLoad(_ sender: Any) {
        
    }
    
     // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.isEdit ? self.scannedSpools.count + (self.load?.spools.count)! : self.scannedSpools.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as? LoadCell
        var spool:Spool!
        if indexPath.row <= (self.load?.spools.count)! - 1 {
            spool = self.load?.spools[indexPath.row]
        } else {
            spool = self.scannedSpools[indexPath.row]
        }
        cell?.spoolLbl.text = "\(spool.code!)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: Scan Delegate Methods
    func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            //self.scanCode = "kndsfjk"
            //BKIModel.setSpoolNumebr(number: self.scanCode)
            return
        }
        let spool = Spool.init(info: ["code":data?.stringValue! as AnyObject])
        scannedSpools.append(spool)
        self.tableView.reloadData()
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error,
                              from connection: AVCaptureConnection) {
        self.setScanCode(data: nil)
    }

}
