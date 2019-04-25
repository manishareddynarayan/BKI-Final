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
        if self.spool?.welds.count == 0 {
            self.tableView.isHidden = true
            rejectBtn.isEnabled = true
            rejectBtn.alpha = 1
            approveBtn.isEnabled = checkHeatNumbers() ? true : false
            approveBtn.alpha = checkHeatNumbers() ? 1 : 0.5
        }
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
    }
    
    @IBAction func approveWeldsAction(_ sender: Any) {
        (self.spool?.welds.count)! > 0 ? self.updateWeldsWith("verify", rejectReason: nil, isSpoolUpdate:false, updateTableView: tableView, caller: "qa") : self.updateWeldsWith("accepted", rejectReason: nil, isSpoolUpdate:true, updateTableView: tableView, caller: "qa")
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
    }
    
    @IBAction func rejectWeldsAction(_ sender: Any) {
        shouldRejectWholeSpool = false
        rejectWelds(andUpdate: self.tableView, caller: "qa")
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
    }
    
    func rejectSpoolButtonState() {
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
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
        if weld!.state != WeldState.qa{
            cell?.isUserInteractionEnabled = false
            cell?.weldLbl.alpha = 0.5
            cell?.statusLbl.alpha = 0.5
        }
        cell?.configureWeld(weld: weld!)
        cell?.selectionChangeddBlock = { (isChecked) in
            weld?.isChecked = isChecked
            tableView.reloadData()
            self.showActionButtons(approveBtn: self.approveBtn, rejectBtn: self.rejectBtn)
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
