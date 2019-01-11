//
//  NewLoadVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class NewLoadVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,ScannerDelegate, UITextFieldDelegate, TextInputDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var spoolArr = [String]()
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var scanBtn: UIButton!
    @IBOutlet weak var truckNumberTF: AUTextField!
    
    var load:Load?
    var isEdit = false
    var scannedSpools = [Spool]()
    var newMaterials = [Material]()
    @IBOutlet var miscBtn: UIBarButtonItem!
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LoadCell", bundle: nil), forCellReuseIdentifier: "loadCell")
        self.navigationItem.rightBarButtonItem = miscBtn
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        if load == nil { self.navigationItem.title = "New Load" }
        load == nil ? self.load = Load() : self.getLoadDetails()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        truckNumberTF.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveBtn.isEnabled = scannedSpools.count > 0 || self.load!.materials.count > 0 ? true : false
        self.truckNumberTF.text = load?.truckNumber
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewLoad() {
        MBProgressHUD.showHud(view: self.view)
        let params = ["status":"open"]
        self.httpWrapper.performAPIRequest("loads/", methodType: "POST",
                                           parameters: ["load":params as AnyObject], successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                if self.load == nil {
                                                    self.load = Load()
                                                }
                                                self.load!.saveLoad(loadInfo: responseData)
                                                self.navigationItem.title = "Load Number " + self.load!.number!
                                                self.bottomView.isHidden = false
                                            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
            DispatchQueue.main.async {
                self.bottomView.isHidden = true
            }
        }
    }
    
    func getLoadDetails() {
        MBProgressHUD.showHud(view: self.view)
        
        self.navigationItem.title = "Load Number " + self.load!.number!
        self.httpWrapper.performAPIRequest("loads/\(self.load!.id!)", methodType: "GET",
                                           parameters: nil, successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                self.load!.saveLoad(loadInfo: responseData)
                                                self.tableView.reloadData()
                                            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
            
        }
    }
    
    @IBAction override func moreAction(_ sender: Any) {
        let miscClosure: () -> Void = {
            self.performSegue(withIdentifier: "showMiscSegue", sender: self)
        }
        let submitClosure: () -> Void = {
            self.updateLoad(isSubmit: true)
        }
        let cancelClosure: () -> Void = {
            
        }
        let buttonTitles = scannedSpools.count > 0 || self.load!.materials.count > 0 ? ["Cancel","Miscellaneous","Submit"] :  ["Cancel","Miscellaneous"]
        self.alertVC.presentActionSheetWithActionsAndTitle(actions:
            [cancelClosure,miscClosure,submitClosure], buttonTitles:
            buttonTitles, controller: self, title: "Choose Option")
        return
    }
    
    @IBAction func scanAction(_ sender: Any) {
        
        self.showScanner()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.updateLoad(isSubmit: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-")
        let stringFromTextField = NSCharacterSet.init(charactersIn: string)
        let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
        return strValid
    }
    
    func updateLoad(isSubmit:Bool) {
        var loadParams:[String:AnyObject] = [String:AnyObject]()
        var params = [String:AnyObject]()
        if scannedSpools.count > 0 {
            loadParams["spool_ids"] =  self.getSPoolParams()
        }
        if truckNumberTF.text?.count != 0 {
            loadParams["truck_number"] = truckNumberTF.text as AnyObject
        }
        if  self.load!.materials.count > 0 {
            let (misc1, misc2) = self.getMiscMaterialParams()
            loadParams["loads_miscellaneous_materials_attributes"] = misc1 as AnyObject
            //            loadParams["miscellaneous_material"] = misc2 as AnyObject
        }
        var endPoint = "loads/"
        var method = "POST"
        if self.load?.id != nil {
            loadParams["id"] = self.load!.id! as AnyObject
            endPoint.append("\(self.load!.id!)")
            method = "PUT"
        } else if isSubmit {
            params["submit"] = true as AnyObject
        }
        
        if isSubmit {
            if truckNumberTF.text?.count == 0 {
                let okClosure: () -> Void = {
                    
                }
                self.alertVC.presentAlertWithTitleAndActions(actions: [okClosure], buttonTitles: ["OK"], controller: self, message: "Please fill truck number field to submit the load", title: "Error")
                return
            }
            params["submit"] = true as AnyObject
        } else {
            loadParams["status"] = "open" as AnyObject
        }
        
        params["load"] = loadParams as AnyObject
        MBProgressHUD.showHud(view: self.view)
        self.httpWrapper.performAPIRequest(endPoint, methodType: method,
                                           parameters: params as [String : AnyObject],
                                           successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                self.load!.saveLoad(loadInfo: responseData)
                                                let okClosure: () -> Void = {
                                                    if isSubmit {
                                                        let vv = self.navigationController?.viewControllers.first(where: { (vc) -> Bool in
                                                            return vc is OpenLoadVC
                                                        })
                                                        if  let v = vv as? OpenLoadVC {
                                                            let index = v.openLoadsArr.lastIndex(of: self.load!)
                                                            v.openLoadsArr.remove(at: index!)
                                                            v.tableView.reloadData()
                                                        }
                                                    }
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                                self.alertVC.presentAlertWithTitleAndActions(actions: [okClosure],
                                                                                             buttonTitles: ["OK"], controller: self,
                                                                                             message:"Load updated successfully." , title: "Success")
                                            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    func getSPoolParams() -> AnyObject {
        var spoolIds = [String]()
        for spool in scannedSpools {
            //spoolIds.append("1")
            spoolIds.append("\((spool.id)!)")
        }
        return spoolIds as AnyObject
    }
    
    func getMiscMaterialParams() -> (misc1:AnyObject, misc2:AnyObject) {
        //Add metrail params to this arr if material is already exists
        var misc_material_attributes = [[String:AnyObject]]()
        //Add metrail params to this arr if material is already not exists
        var misc_materia_params = [[String:AnyObject]]()
        for material in self.load!.materials {
            if material.miscellaneousMaterialId == nil {
                let dict = ["material":material.desc,"quantity":material.quantity,"weight": material.weight] as [String : Any]
                misc_material_attributes.append(dict as [String : AnyObject])
            } else {
                var dict = ["miscellaneous_material_id":material.miscellaneousMaterialId!,"quantity":material.quantity,"weight": material.weight] as [String : Any]
                if material.id != nil {
                    dict["id"] = material.id!
                }
                misc_material_attributes.append(dict as [String : AnyObject])
            }
        }
        var misc1 = [String:AnyObject]()
        var misc2 =  [String:AnyObject]()
        if misc_material_attributes.count > 0 {
            for (idx,ma) in misc_material_attributes.enumerated() {
                let i = "\(idx)"
                misc1[i] = ma as AnyObject
            }
        }
        if misc_materia_params.count > 0 {
            for (idx,ma) in misc_materia_params.enumerated() {
                let i = "\(idx)"
                misc2[i] = ma as AnyObject
            }
        }
        return(misc1 as AnyObject, misc2 as AnyObject)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let miscVC = segue.destination as? LoadMiscTVC
        miscVC?.load = self.load!
    }
    
    //MARK:- TableView DataSource methods
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
            let row = indexPath.row - (self.load?.spools.count)!
            spool = self.scannedSpools[row]
        }
        cell?.spoolLbl.text = "\(spool.code!)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getSpool() -> Void {
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(self.scanCode!)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                let spool  = Spool.init(info: responseData)
                if spool.status == "On Hold" {
                    self.showFailureAlert(with: "The Spool is on hold and hence no operation can be performed on it.")
                } else if (self.role == 3 && spool.state != WeldState.readyToShip) {
                    self.showFailureAlert(with: "You can access spools which are in state of ready to ship.")
                    return
                }
                self.scannedSpools.append(spool)
                BKIModel.setSpoolNumebr(number: self.spool?.code!)
                self.saveBtn.isEnabled = self.scannedSpools.count > 0 || self.load!.materials.count > 0 ? true : false
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.spool = nil
                if error?.code == 403 {
                    self.showFailureAlert(with: error!.localizedDescription)
                    return
                }
                self.showFailureAlert(with: (error?.localizedDescription)!)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Scan Delegate Methods
    func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            //self.scanCode = "kndsfjk"
            //BKIModel.setSpoolNumebr(number: self.scanCode)
            return
        }
        let spoolId = data?.stringValue!.components(separatedBy: "_").last
        var isFound = false
        var isFound1 = false
        isFound = ((self.load?.spools.contains { (spool) -> Bool in
            return spool.id == Int(spoolId!)
            })!)
        isFound1 = self.scannedSpools.contains { (spool) -> Bool in
            return spool.id == Int(spoolId!)
        }
        guard !isFound && !isFound1 else {
            self.showFailureAlert(with: "Spool already added to load.")
            return
        }
        
        self.scanCode = spoolId
        
        self.getSpool()
        //        let spool = Spool.init(info: ["id":spoolId as AnyObject])
        //        scannedSpools.append(spool)
        //        self.tableView.reloadData()
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error,
                              from connection: AVCaptureConnection) {
        self.setScanCode(data: nil)
    }
    
}
