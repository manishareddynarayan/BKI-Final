//
//  NewLoadVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class NewLoadVC: BaseViewController, TextInputDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var scanBtn: UIButton!
    @IBOutlet weak var truckNumberTF: AUTextField!
    @IBOutlet weak var totalWeightLbl: UILabel!
    @IBOutlet var miscBtn: UIBarButtonItem!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addUsersBtn: UIButton!
    @IBOutlet weak var additionalUsersCountLabel: UILabel!
    //MARK:- properties
    var spoolArr = [String]()
    var load:Load?
    var isEdit = false
    var scannedSpools = [Spool]()
    var scannedHangers = [Hanger]()
    var scannedEvolves = [Evolve]()
    var newMaterials = [Material]()
    fileprivate var deletedSpools = [Spool]()
    fileprivate var deletedHangers = [Hanger]()
    fileprivate var deletedEvolves = [Evolve]()
    var enableAdditionalUsersBtn = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LoadCell", bundle: nil), forCellReuseIdentifier: "loadCell")
        tableView.register(UINib(nibName: "SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeader.reuseIdentifier)
        
        self.navigationItem.rightBarButtonItem = miscBtn
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        if load == nil { self.navigationItem.title = "New Load" }
        load?.number == nil ? self.load = Load() : self.getLoadDetails()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        truckNumberTF.delegate = self
        self.handleAddUsersTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.truckNumberTF.text = (load?.truckNumber != nil) ? load?.truckNumber : UserDefaults.standard.value(forKey: "truck_number") as? String
        saveBtn.isEnabled =  !(scannedEvolves.isEmpty) || !(scannedHangers.isEmpty) || !(scannedSpools.isEmpty) || !(self.load!.materials.isEmpty) || !((self.load?.spools.isEmpty)!) || !((self.load?.hangers.isEmpty)!) || self.truckNumberTF.text != ""
        self.handleAddUsersTitle()
        enableAdditionalUsersBtn = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
        addUsersBtn.isEnabled = enableAdditionalUsersBtn
        addUsersBtn.titleLabel?.isEnabled = enableAdditionalUsersBtn
        self.setTotalWeight()
    }
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let miscVC = segue.destination as? LoadMiscTVC
        miscVC?.load = self.load!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction override func moreAction(_ sender: Any) {
        UserDefaults.standard.set(truckNumberTF.text, forKey: "truck_number")
        var shouldSubmit = false
        let miscClosure: () -> Void = {
            self.performSegue(withIdentifier: "showMiscSegue", sender: self)
        }
        let submitClosure: () -> Void = {
            self.updateLoad(isSubmit: true)
        }
        let cancelClosure: () -> Void = {
            
        }
        let buttonTitles = ["Cancel","Add Misc Material","Submit"]
        if !(scannedSpools.isEmpty) || !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.load!.materials.isEmpty) ||  !((load?.spools.isEmpty)!) || !((load?.evolves.isEmpty)!) || !((load?.hangers.isEmpty)!) {
            shouldSubmit = true
        }
        self.alertVC.presentActionSheetWithActionsAndTitle(actions:
                                                            [cancelClosure,miscClosure,submitClosure], buttonTitles:
                                                                buttonTitles, controller: self, title: "Choose Option", shouldSubmit: shouldSubmit)
        return
    }
    
    @IBAction func scanAction(_ sender: Any) {
        UserDefaults.standard.set(truckNumberTF.text, forKey: "truck_number")
        self.showScanner()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if (truckNumberTF.text?.count)! > 10{
            self.alertVC.presentAlertWithTitleAndMessage(title: "Failed", message: "Truck number should not contain more than 10 characters", controller: self)
        }else{
            self.updateLoad(isSubmit: false)
        }
    }
    
    @IBAction func addUsersAction(_ sender: Any) {
        guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier:
                                                                            "AdditionalUsersViewController", storyBoard: "Main") as? AdditionalUsersViewController else {
            return
        }
        
        if self.trackerId != nil {
            vc.trackerId = self.trackerId
        }
        vc.trackerIds = Array(Set(self.trackerIds))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleAddUsersTitle() {
        addUsersBtn.setTitle("", for: .normal)
        if let additionalUsers = UserDefaults.standard.array(forKey: "additional_users") {
            addUsersBtn.setTitle(String(additionalUsers.count), for: .normal)
        }
    }
    
    func showDrawingVC(spool:Spool?,hanger:Hanger?,evolve:Evolve?,role:Int,state:WEBURLState){
        if let vc = self.getViewControllerWithIdentifier(identifier: "DrawingVC") as? DrawingVC
        {
            if spool != nil {
                vc.spool = spool
            } else if hanger != nil  {
                vc.hanger = hanger
            } else {
                vc.evolve = evolve
            }
            vc.role = role
            vc.urltype = state
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- Private methods
private extension NewLoadVC
{
    func updateUI()
    {
        if load == nil { self.navigationItem.title = "New Load" }
        //load == nil ? self.load = Load() : self.getLoadDetails()
        self.truckNumberTF.text = (load?.truckNumber != nil) ? load?.truckNumber : UserDefaults.standard.value(forKey: "truck_number") as? String
        self.setTotalWeight()
        self.truckNumberTF.text = self.load?.truckNumber
        self.saveBtn.isEnabled = !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !(self.load!.materials.isEmpty) || !((self.load?.spools.isEmpty)!) || self.truckNumberTF.text != ""
        self.addUsersBtn.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
        addUsersBtn.titleLabel?.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
        self.tableView.reloadData()
    }
    
    func setTotalWeight(){
        var weight = 0.0
        for spool in (load?.spools)!{
            weight += spool.weight
        }
        for material in (load?.materials)!{
            weight += material.weight
        }
        for spool in scannedSpools{
            weight += spool.weight
        }
        self.load?.total_weight = weight
        self.totalWeightLbl.text = String(format: "%.2f", weight)
    }
    
    func getMiscMaterialParams() -> (misc1:AnyObject, misc2:AnyObject) {
        //Add metrail params to this arr if material is already exists
        var misc_material_attributes = [[String:AnyObject]]()
        //Add metrail params to this arr if material is already not exists
        let misc_materia_params = [[String:AnyObject]]()
        for material in self.load!.materials {
            if material.miscellaneousMaterialId == nil {
                let dict = ["material":material.desc as Any,"quantity":material.quantity,"weight": material.weight] as [String : Any]
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
        if !(misc_material_attributes.isEmpty) {
            for (idx,ma) in misc_material_attributes.enumerated() {
                let i = "\(idx)"
                misc1[i] = ma as AnyObject
            }
        }
        if !(misc_materia_params.isEmpty) {
            for (idx,ma) in misc_materia_params.enumerated() {
                let i = "\(idx)"
                misc2[i] = ma as AnyObject
            }
        }
        return(misc1 as AnyObject, misc2 as AnyObject)
    }
    
    func getSpoolAtRow(indexPath:IndexPath) -> Spool {
        var spool:Spool!
        if indexPath.row <= (self.load?.spools.count)! - 1 {
            spool = self.load?.spools[indexPath.row]
        } else {
            let row = indexPath.row - (self.load?.spools.count)!
            spool = self.scannedSpools[row]
        }
        return spool
    }
}


//MARK:- UITextFieldDelegate Methods
extension NewLoadVC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveBtn.isEnabled = !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(scannedSpools.isEmpty) || !(self.load!.materials.isEmpty) || !((self.load?.spools.isEmpty)!) || !((self.load?.hangers.isEmpty)!) || textField.text?.count ?? 0 > 0
        addUsersBtn.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
        addUsersBtn.titleLabel?.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-")
        let stringFromTextField = NSCharacterSet.init(charactersIn: string)
        let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
        return strValid
    }
}

//MARK:- APICalls
extension NewLoadVC
{
    // gettingload details by loadid
    func getLoadDetails() {
        MBProgressHUD.showHud(view: self.view)
        
        self.navigationItem.title = "Load Number " + self.load!.number!
        self.httpWrapper.performAPIRequest("loads/\(self.load!.id!)", methodType: "GET",
                                           parameters: nil, successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                self.load!.saveLoad(loadInfo: responseData)
                                                self.truckNumberTF.text = self.load?.truckNumber
                                                self.totalWeightLbl.text = String(format: "%.2f",  (self.load?.total_weight)!)
                                                self.saveBtn.isEnabled = !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!)  || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !(self.load!.materials.isEmpty) || !((self.load?.spools.isEmpty)!)
                                                self.addUsersBtn.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                                                self.addUsersBtn.titleLabel?.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                                                self.tableView.reloadData()
                                            }
                                           }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
            
        }
    }
    // getting spool details
    func getHangerAtRow(indexPath:IndexPath) -> Hanger {
        var hanger:Hanger!
        if indexPath.row <= (self.load?.hangers.count)! - 1 {
            hanger = self.load?.hangers[indexPath.row]
        } else {
            let row = indexPath.row - (self.load?.hangers.count)!
            hanger = self.scannedHangers[row]
        }
        return hanger
    }
    
    func getEvolveAtRow(indexPath:IndexPath) -> Evolve {
        var evolve:Evolve!
        if indexPath.row <= (self.load?.evolves.count)! - 1 {
            evolve = self.load?.evolves[indexPath.row]
        } else {
            let row = indexPath.row - (self.load?.evolves.count)!
            evolve = self.scannedEvolves[row]
        }
        return evolve
    }
    
    func getScannedItemDetails() -> Void {
        if self.scanCode != nil && (self.scanCode?.isEmpty ?? true) {
            return
        }
        MBProgressHUD.showHud(view: self.view)
        if self.scanItem == "Spool" {
            httpWrapper.performAPIRequest("spools/\(self.scanCode!)?scan=true&state=\("ready_to_ship")", methodType: "GET", parameters: nil, successBlock: { (responseData) in
                DispatchQueue.main.async { [self] in
                    MBProgressHUD.hideHud(view: self.view)
                    let spool  = Spool.init(info: responseData)
                    if spool.isArchivedOrRejected! {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Spool is in rejected or archived state hence no operation can be performed on it. You can only view the drawing.", title: "Warning")
                        return
                    }
                    else if spool.status == "On Hold" {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Spool is on hold and hence no operation can be performed on it. You can only view the drawing.", title: "Warning")
                        return
                    }
                    else if (self.role == 3 && (spool.state == WeldState.inShipping || spool.state == WeldState.shipped || spool.loadedAt != nil)) {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Spool is already added to a load. You can view the drawing by clicking on the button below.", title: "Warning")
                        
                        return
                    } else if (self.role == 3 && spool.state != WeldState.readyToShip) {
                        
                        if !spool.isCutListsCompleted!{
                            self.alertVC.presentAlertWithTitleAndActions(actions: [{
                                self.dismiss(animated: true, completion: nil)
                            },{
                                self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                            }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "Please complete all the cut lists to load the spool. You can view the drawing by clicking on the button below.", title: "Warning")
                            return
                        }
                        
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Spool is not ready to be loaded yet. You can view the drawing by clicking on the button below.", title: "Warning")
                        return
                    }
                    else if !self.checkHeatNumbersWithSpool(spool: spool){
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "You cannot add this spool as the heat numbers are not present. You can view the drawing by clicking on the button below.", title: "Warning")
                        return
                    }
                    
                    for spl in self.scannedSpools{
                        if spl.id == spool.id{
                            self.alertVC.presentAlertWithMessage(message: "The spool is already added to this load.", controller: self)
                            return
                        }
                    }
                    
                    self.scannedSpools.append(spool)
                    BKIModel.setSpoolNumebr(number: self.spool?.code!)
                    self.saveBtn.isEnabled = !(self.scannedHangers.isEmpty) || !(self.scannedSpools.isEmpty) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.load!.materials.isEmpty) || !((self.load?.hangers.isEmpty)!) || !((self.load?.spools.isEmpty)!)
                    self.addUsersBtn.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                    addUsersBtn.titleLabel?.isEnabled = load != nil ?  !(scannedHangers.isEmpty) || !(scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                    self.tableView.reloadData()
                    self.setTotalWeight()
                    
                    if let projectId = self.load?.projectId{
                        if projectId != spool.projectId{
                            self.alertVC.presentAlertWithTitleAndMessage(title: "Warning", message: "The scanned spool is from a different project. ", controller: self)
                        }
                    }else{
                        self.load?.projectId = spool.projectId
                    }
                    if self.trackerId == nil && (UserDefaults.standard.value(forKey: "spoolFabricationId") as? Int != nil ? UserDefaults.standard.value(forKey: "spoolFabricationId") as? Int != self.spool?.fabricationId : true) {
                        self.startTracker(with: spool.fabricationId!, atShipping: true)
                    }
                    UserDefaults.standard.set(spool.fabricationId, forKey: "spoolFabricationId")
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
        } else if self.scanItem == "Hanger" {
            httpWrapper.performAPIRequest("hangers/\(self.scanCode!)/scan?state=\("ready_to_ship")", methodType: "GET", parameters: nil, successBlock: { (responseData) in
                var hanger:Hanger?
                DispatchQueue.main.async {
                    MBProgressHUD.hideHud(view: self.view)
                    hanger = Hanger.init(info: responseData)
                    if hanger!.isArchivedOrRejected! {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: nil, hanger: hanger, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Hanger is in rejected or archived state hence no operation can be performed on it. You can only view the drawing.", title: "Warning")
                        return
                    }else if hanger?.loadId != nil {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: nil, hanger: hanger, evolve: nil, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Spool Drawing"], controller: self, message: "The Hanger is already added to a load. You can view the drawing by clicking on the button below.", title: "Warning")
                        return
                    } else if hanger?.hangerState == "fabrication" {
                        self.alertVC.presentAlertWithMessage(message: "Kindly complete cutting process for this hanger.", controller: self)
                        return
                    }
                    if hanger?.hangerState == "procure" || hanger?.hangerState == "receive"{
                        self.alertVC.presentAlertWithMessage(message: "Kindly complete procurement process for this hanger.", controller: self)
                        return
                    }
                    for spl in self.scannedHangers{
                        if spl.id == hanger?.id{
                            self.alertVC.presentAlertWithMessage(message: "The hanger is already added to this load.", controller: self)
                            return
                        }
                    }
                    
                    self.scannedHangers.append(hanger!)
                    self.saveBtn.isEnabled = !(self.scannedHangers.isEmpty) || !(self.scannedSpools.isEmpty) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.load!.materials.isEmpty) || !((self.load?.hangers.isEmpty)!) || !((self.load?.spools.isEmpty)!)
                    self.addUsersBtn.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                    self.addUsersBtn.titleLabel?.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)

                    if self.trackerId == nil {
                        self.startTracker(with: (hanger?.id)!, atShipping: true)
                    }
                    self.tableView.reloadData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.showFailureAlert(with: (error?.localizedDescription)!)
                }
            }
        } else if self.scanItem == "EvolveFabrication" {
            httpWrapper.performAPIRequest("evolve_fabrications/\(self.scanCode!)/scan?state=\("ready_to_ship")", methodType: "GET", parameters: nil) { (responseData) in
                var evolve:Evolve?
                DispatchQueue.main.async {
                    MBProgressHUD.hideHud(view: self.view)
                    evolve = Evolve.init(info: responseData)
                    if (!(evolve?.isInFabrication)! && evolve?.evolveState != "cutting") {
                        self.showFailureAlert(with:"This is not in fabrication" )
                        return
                    } else if evolve?.loadId != nil {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: nil, hanger: nil, evolve: evolve, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Evolve Drawing"], controller: self, message: "The Evolve is already added to a load. You can view the drawing by clicking on the button below.", title: "Warning")
                        return
                    } else if evolve?.evolveState != "ready_to_ship" {
                        self.alertVC.presentAlertWithTitleAndActions(actions: [{
                            self.dismiss(animated: true, completion: nil)
                        },{
                            self.showDrawingVC(spool: nil, hanger: nil, evolve: evolve, role: self.role, state: .pdfURL)
                        }], buttonTitles: ["OK","View Evolve Drawing"], controller: self, message: "The Evolve is not ready to be loaded yet. You can view the drawing by clicking on the button below.", title: "Warning")
                        return
                    }
                    for spl in self.scannedEvolves{
                        if spl.id == evolve?.id{
                            self.alertVC.presentAlertWithMessage(message: "The evolve is already added to this load.", controller: self)
                            return
                        }
                    }
                    self.evolve = evolve
                    self.scannedEvolves.append(evolve!)
                    self.saveBtn.isEnabled = !(self.scannedHangers.isEmpty) || !(self.scannedSpools.isEmpty) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.load!.materials.isEmpty) || !((self.load?.hangers.isEmpty)!) || !((self.load?.spools.isEmpty)!)
                    self.addUsersBtn.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                    self.addUsersBtn.titleLabel?.isEnabled = self.load != nil ?  !(self.scannedHangers.isEmpty) || !(self.scannedEvolves.isEmpty) || !(self.scannedSpools.isEmpty): !(self.scannedHangers.isEmpty) || !((self.load?.hangers.isEmpty)!) || !(self.scannedEvolves.isEmpty) || !((self.load?.evolves.isEmpty)!) || !(self.scannedSpools.isEmpty) || !((self.load?.spools.isEmpty)!)
                    if self.trackerId == nil {
                        self.startTracker(with: (evolve?.id)!, atShipping: true)
                    }
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
    }
    
    
}
//MARK:- Scan Delegate Methods
extension NewLoadVC:  ScannerDelegate{
    func scanDidCompletedWith(_ data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            return
        }
        if (data?.stringValue!.contains(":") ?? false) {
            let fullString = data?.stringValue!.split(separator: ":")
            self.scanItem = String((fullString?[0])!)
            self.scanCode = String((fullString?[1])!).trimmingCharacters(in: .whitespaces)//.components(separatedBy: "_").last
        } else {
            self.scanItem = "Spool"
            self.scanCode = data?.stringValue ?? ""
        }
        self.getScannedItemDetails()
    }
    
    func scanDidCompletedWith(_ output: AVCaptureMetadataOutput, didError error: Error,
                              from connection: AVCaptureConnection) {
        self.setScanCode(data: nil)
    }
}

extension NewLoadVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.isEdit ? (section == 0 ? (self.scannedSpools.count + (self.load?.spools.count)! != 0 ? self.scannedSpools.count + (self.load?.spools.count)! : 1) : section == 1 ? (self.scannedHangers.count + (self.load?.hangers.count)! != 0 ? self.scannedHangers.count + (self.load?.hangers.count)! : 1) : (self.scannedEvolves.count + (self.load?.evolves.count)! != 0 ? self.scannedEvolves.count + (self.load?.evolves.count)! : 1)) : section == 0 ? (self.scannedSpools.count != 0 ? self.scannedSpools.count : 1) : section == 1 ?  (self.scannedHangers.count != 0 ? self.scannedHangers.count : 1) : (self.scannedEvolves.count != 0 ? self.scannedEvolves.count : 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionHeader
        headerView?.titleLabel.text = section == 0 ? "Spoolgen Fab" : section == 1 ? "Hangers" : "Pipe Assembly Fab"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isEmpty = self.isEdit ? (indexPath.section == 0 ? (self.scannedSpools.count + (self.load?.spools.count)! != 0 ? false : true) : indexPath.section == 1 ? (self.scannedHangers.count + (self.load?.hangers.count)! != 0 ? false : true) : (self.scannedEvolves.count + (self.load?.evolves.count)! != 0 ? false : true)) : indexPath.section == 0 ? (self.scannedSpools.count != 0 ? false : true) : indexPath.section == 1 ? (self.scannedHangers.count != 0 ? false : true) : (self.scannedEvolves.count != 0 ? false : true)
        if isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as? LoadCell
            cell?.spoolLbl.text = "No data found"
            cell?.viewDrawingBtn.isHidden = true
            cell?.deleteSpoolButton.isHidden = true
            cell?.isoButton.isHidden = true
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as? LoadCell
        cell?.viewDrawingBtn.isHidden = false
        cell?.viewDrawingBtn.setImage(UIImage.init(named: "SpoolPdf"), for: .normal)
        cell?.deleteSpoolButton.isHidden = false
        cell?.isoButton.isHidden = false
        if indexPath.section == 0 {
            let spool = getSpoolAtRow(indexPath: indexPath)
            if load != nil && spool.trackerId != nil{
                self.trackerIds.append(spool.trackerId!)
            }
            cell?.spoolLbl.text = "\(spool.code!)"
            cell?.viewDrawingBlock = {
                self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .pdfURL)
            }
            cell?.deleteSpoolBlock = {
                
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    if self.deletedSpools.contains(spool)
                    {
                        
                    }
                    else
                    {
                        self.deletedSpools.append(spool)
                    }
                    if self.isEdit
                    {
                        self.scannedSpools.removeAll { $0.id == spool.id }
                        self.load?.spools.removeAll { $0.id == spool.id }
                    }
                    else
                    {
                        self.scannedSpools.removeAll { $0.id == spool.id }
                    }
                    self.updateUI()
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
            cell?.isoButton.isHidden = (spool.isoDrawingURL == nil)
            cell?.viewISODrawingBlock = {
                guard (spool.isoDrawingURL != nil) else {
                    self.alertVC.presentAlertWithMessage(message: "No ISO URL found", controller: self)
                    return
                }
                self.showDrawingVC(spool: spool, hanger: nil, evolve: nil, role: self.role, state: .ISOURL)
            }
            
        } else if indexPath.section == 1 {
            let hanger = getHangerAtRow(indexPath: indexPath)
            if load != nil && hanger.trackerId != nil {
                self.trackerIds.append(hanger.trackerId!)
            }
            cell?.spoolLbl.text = "\(hanger.packageName!)"
            cell?.viewDrawingBtn.isHidden = false
            cell?.viewDrawingBtn.setImage(UIImage.init(named: "Hangers_Pdf"), for: .normal)
            cell?.viewDrawingBlock = {
                self.showDrawingVC(spool: nil, hanger: hanger, evolve: nil, role: self.role, state: .pdfURL)
            }
            cell?.deleteSpoolBlock = {
                
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    if self.deletedHangers.contains(hanger)
                    {
                        
                    }
                    else
                    {
                        self.deletedHangers.append(hanger)
                    }
                    if self.isEdit
                    {
                        self.scannedHangers.removeAll { $0.id == hanger.id }
                        self.load?.hangers.removeAll { $0.id == hanger.id }
                    }
                    else
                    {
                        self.scannedHangers.removeAll { $0.id == hanger.id }
                    }
                    self.updateUI()
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
            cell?.isoButton.isHidden = true
        } else {
            let evolve = getEvolveAtRow(indexPath: indexPath)
            if load != nil && evolve.trackerId != nil {
                self.trackerIds.append(evolve.trackerId!)
            }
            cell?.spoolLbl.text = "\(evolve.batteryName!)"
            cell?.viewDrawingBtn.isHidden = false
            cell?.viewDrawingBtn.setImage(UIImage.init(named: "evolve_pdf"), for: .normal)
            cell?.viewDrawingBlock = {
                self.showDrawingVC(spool: nil, hanger: nil, evolve: evolve, role: self.role, state: .pdfURL)
            }
            cell?.deleteSpoolBlock = {
                
                // Declare Alert message
                let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    if self.deletedEvolves.contains(evolve)
                    {
                        
                    }
                    else
                    {
                        self.deletedEvolves.append(evolve)
                    }
                    if self.isEdit
                    {
                        self.scannedEvolves.removeAll { $0.id == evolve.id }
                        self.load?.evolves.removeAll { $0.id == evolve.id }
                    }
                    else
                    {
                        self.scannedEvolves.removeAll { $0.id == evolve.id }
                    }
                    self.updateUI()
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
            cell?.isoButton.isHidden = true
        }
//        UserDefaults.standard.set(self.trackerIds, forKey: "activity_tracker_ids")
        return cell!
    }
}
extension NewLoadVC {
    // update load details
    func updateLoad(isSubmit:Bool)
    {
        var loadParams:[String:AnyObject] = [String:AnyObject]()
        
        var params = [String:AnyObject]()
        if !(scannedSpools.isEmpty)
        {
            loadParams["spool_ids"] =  self.scannedSpools.map{($0.id)} as AnyObject
        }
        if !(scannedHangers.isEmpty) && !(scannedEvolves.isEmpty) {
            loadParams["package_material_ids"] = self.scannedHangers.map{($0.id)} + self.scannedEvolves.map{($0.id)} as AnyObject
        } else if !(scannedHangers.isEmpty) {
            loadParams["package_material_ids"] =  self.scannedHangers.map{($0.id)} as AnyObject
        } else if !(scannedEvolves.isEmpty) {
            loadParams["package_material_ids"] =  self.scannedEvolves.map{($0.id)} as AnyObject
        }
        
        loadParams["truck_number"] = truckNumberTF.text as AnyObject
        if  !(self.load!.materials.isEmpty)
        {
            let (misc1, misc2) = self.getMiscMaterialParams()
            loadParams["loads_miscellaneous_materials_attributes"] = misc1 as AnyObject
        }
        var endPoint = "loads/"
        var method = "POST"
        if self.load?.id != nil
        {
            loadParams["id"] = self.load!.id! as AnyObject
            endPoint.append("\(self.load!.id!)")
            method = "PUT"
            loadParams["removed_spool_ids"] =  self.deletedSpools.compactMap({$0.id!}) as AnyObject
            let deletedPackageMaterialIds = self.deletedHangers.compactMap({$0.id!}) + self.deletedEvolves.compactMap({$0.id!})
            loadParams["removed_package_material_ids"] = deletedPackageMaterialIds as AnyObject
        }
        else if isSubmit
        {
            params["submit"] = true as AnyObject
        }
        
        if isSubmit
        {
            if (truckNumberTF.text?.isEmpty)!
            {
                let okClosure: () -> Void = {
                    
                }
                self.alertVC.presentAlertWithTitleAndActions(actions: [okClosure], buttonTitles: ["OK"], controller: self, message: "Please fill truck number field to submit the load", title: "Error")
                return
            }
            params["submit"] = true as AnyObject
        }
        else
        {
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
                                                    self.stopTracking()
                                                    UserDefaults.standard.removeObject(forKey: "truck_number")
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
}
