//
//  InspectionVC.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectSpoolBtn: UIButton!
    var IDTestMethodsWelds : [String:([String:String])] = [String: [String:String]]()
    var ODTestMethodsWelds : [String:([String:String])] = [String: [String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "InspectionCell", bundle: nil), forCellReuseIdentifier: "inspectionCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetWeldStatus()
        self.showActionButtons(approveBtn: approveBtn, rejectBtn: rejectBtn)
        self.tableView.reloadData()
        if (self.spool?.welds.isEmpty)! {
            self.tableView.isHidden = true
            rejectBtn.isEnabled = false
            approveBtn.isEnabled = false
            emptyView.isHidden = false
        }
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
    }
    
    @IBAction func approveWeldsAction(_ sender: Any) {
        if  !checkHeatNumbers() {
            let welds = self.spool!.welds.filter({ (weld) -> Bool in
                return  weld.state == .verified
            })
            if self.spool?.welds.count == welds.count + self.getSelectedWeldIds().count {
                let okClosure: () -> Void = {
                    self.tableView.reloadData()
                }
                alertVC.presentAlertWithTitleAndActions(actions: [okClosure], buttonTitles: ["OK"], controller: self, message: "Please enter heat numbers.", title: "Error")
            } else {
//                updateWeldStatus()
            }
        }
        updateWeldStatus()
    }
    
    @IBAction func rejectWeldsAction(_ sender: Any) {
        shouldRejectWholeSpool = false
        rejectWelds(andUpdate: self.tableView, caller: "qa")
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
        self.showActionButtons(approveBtn: approveBtn, rejectBtn: rejectBtn)
    }
    
    func rejectSpoolButtonState() {
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
    }
    
    func updateWeldStatus() {
        !((self.spool?.welds.isEmpty)!) ? self.updateWeldsWith("verify", rejectReason: nil, isSpoolUpdate: false, updateTableView: tableView, caller: "qa", odTestMethodsWelds: ODTestMethodsWelds, idTestMethodsWelds: IDTestMethodsWelds) : self.updateWeldsWith("accepted", rejectReason: nil, isSpoolUpdate: true, updateTableView: tableView, caller: "qa", odTestMethodsWelds: ODTestMethodsWelds, idTestMethodsWelds: IDTestMethodsWelds)
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
    }
    
    @IBAction func rejectWholeSpool(_ sender: Any) {
        shouldRejectWholeSpool = true
        rejectWelds(andUpdate: self.tableView, caller: "qa")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.spool?.welds.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inspectionCell") as? InspectionCell
        let weld = self.spool?.welds[indexPath.row]
        let IDTestMethods = self.spool?.IDTestMethods
        let ODTestMethods = self.spool?.ODTestMethods
        if weld!.state != WeldState.qa {
            cell?.isUserInteractionEnabled = false
            cell?.weldLbl.alpha = 0.5
            cell?.statusImageView.alpha = 0.5
        }
        cell?.configureWeld(weld: weld!, IDTestMethods: IDTestMethods!, ODTestMethods: ODTestMethods!)
        cell?.selectionChangeddBlock = { (isChecked) in
            if (weld?.idTestMethod == nil || weld?.odTestMethod == nil) &&  weld?.isChecked == false {
                weld?.isChecked = false
                tableView.reloadData()
                self.alertVC.presentAlertWithMessage(message: "Both ID test method and OD test method needs to be selected.", controller: self)
            } else if weld?.idTestMethod == "N/A" && weld?.odTestMethod == "n/a" && weld?.isChecked == false {
                weld?.isChecked = false
                tableView.reloadData()
                self.alertVC.presentAlertWithMessage(message: "Both ID test method and OD test method can't be n/a", controller: self)
            } else {
                weld?.isChecked = isChecked
                tableView.reloadData()
                self.showActionButtons(approveBtn: self.approveBtn, rejectBtn: self.rejectBtn)
            }
        }
        
        cell?.IDTestMethodChangeddBlock = { (testMethod) -> () in
            weld?.idTestMethod = testMethod
            if weld?.idTestMethod == "N/A" && weld?.odTestMethod == "n/a" && (weld?.isChecked == true) {
                weld?.isChecked = false
                tableView.reloadData()
                self.alertVC.presentAlertWithMessage(message: "Both ID test method and OD test method can't be n/a", controller: self)
            } else {
                self.IDTestMethodsWelds[String(weld!.id!)] = ["id_test_method":testMethod]
            }
        }
        cell?.ODTestMethodChangeddBlock = { (testMethod) -> () in
            weld?.odTestMethod = testMethod
            if weld?.idTestMethod == "N/A" && weld?.odTestMethod == "n/a" && (weld?.isChecked == true) {
                weld?.isChecked = false
                tableView.reloadData()
                self.alertVC.presentAlertWithMessage(message: "Both ID test method and OD test method can't be n/a", controller: self)
            } else {
                self.ODTestMethodsWelds[String(weld!.id!)] = ["od_test_method":testMethod]
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weld = self.spool?.welds[indexPath.row]
        if  weld?.state == .complete || weld?.state == .reject{
            return
        }
        weld?.isChecked = !(weld?.isChecked)!
        tableView.reloadData()
        self.showActionButtons(approveBtn: self.approveBtn, rejectBtn: self.rejectBtn)
    }
}
