//
//  InspectionVC.swift
//  BKI
//
//  Created by srachha on 18/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class InspectionVC: BaseViewController
{
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectSpoolBtn: UIButton!
    //MARK:- Properties
    //    var testMethodsWelds : [String:([Int:([String:String])])] = ["test_method_welds": [Int: [String:String]]()]
    var testMethodsWelds : [String:([String:String])] = [String: [String:String]]()
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.registerReusableCell(InspectionCell.self)
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.resetWeldStatus()
        self.showActionButtons(approveBtn: approveBtn, rejectBtn: rejectBtn)
        self.tableView.reloadData()
        if (self.spool?.welds.isEmpty)!
        {
            self.tableView.isHidden = true
            rejectBtn.isEnabled = false
            approveBtn.isEnabled = false
            emptyView.isHidden = false
            //            rejectBtn.alpha = 0.5
            //            approveBtn.isEnabled = checkHeatNumbers() ? true : false
            //            approveBtn.alpha = checkHeatNumbers() ? 1 : 0.5
        }
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
    }
    //MARK:- IBActions
    @IBAction func approveWeldsAction(_ sender: Any)
    {
        if  !checkHeatNumbers()
        {
            let welds = self.spool!.welds.filter({ (weld) -> Bool in
                return  weld.state == .verified
            })
            if self.spool?.welds.count == welds.count + self.getSelectedWeldIds().count
            {
                let okClosure: () -> Void = {
                    self.tableView.reloadData()
                }
                alertVC.presentAlertWithTitleAndActions(actions: [okClosure], buttonTitles: ["OK"], controller: self, message: "Please enter heat numbers.", title: "Error")
            }
            else
            {
                //                updateWeldStatus()
            }
        }
        updateWeldStatus()
    }
    
    @IBAction func rejectWeldsAction(_ sender: Any)
    {
        shouldRejectWholeSpool = false
        rejectWelds(andUpdate: self.tableView, caller: "qa")
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
        self.showActionButtons(approveBtn: approveBtn, rejectBtn: rejectBtn)
    }

    @IBAction func rejectWholeSpool(_ sender: Any)
    {
        shouldRejectWholeSpool = true
        rejectWelds(andUpdate: self.tableView, caller: "qa")
    }
}
//MARK:- setup private methods
extension InspectionVC
{
    func rejectSpoolButtonState()
    {
        rejectSpoolBtn.isEnabled = checkQaWeldStatus() ? true : false
        rejectSpoolBtn.alpha = checkQaWeldStatus() ? 1 : 0.5
    }
    
    func updateWeldStatus ()
    {
        !((self.spool?.welds.isEmpty)!) ? self.updateWeldsWith("verify", rejectReason: nil, isSpoolUpdate:false, updateTableView: tableView, caller: "qa", testMethodsWelds: testMethodsWelds) : self.updateWeldsWith("accepted", rejectReason: nil, isSpoolUpdate:true, updateTableView: tableView, caller: "qa", testMethodsWelds: testMethodsWelds)
        approveBtn.isEnabled = false
        approveBtn.alpha = 0.5
        rejectBtn.isEnabled = false
        rejectBtn.alpha = 0.5
        rejectSpoolButtonState()
    }
}
//MARK:- UITableViewDataSource methods
extension InspectionVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.spool?.welds.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: InspectionCell = tableView.dequeueReusableCell(indexPath: indexPath) as InspectionCell
        let weld = self.spool?.welds[indexPath.row]
        let testMethods = self.spool?.testMethods
        if weld!.state != WeldState.qa
        {
            cell.isUserInteractionEnabled = false
            cell.weldLbl.alpha = 0.5
            cell.statusLbl.alpha = 0.5
        }
        cell.configureWeld(weld: weld!, testMethods: testMethods!)
        cell.selectionChangeddBlock = { (isChecked) in
            weld?.isChecked = isChecked
            tableView.reloadData()
            self.showActionButtons(approveBtn: self.approveBtn, rejectBtn: self.rejectBtn)
        }
        
        cell.testMethodChangeddBlock = { (testMethod) -> () in
            self.testMethodsWelds[String(weld!.id!)] = ["test_method":testMethod]
            weld?.testMethod = testMethod
        }
        return cell
    }
}
//MARK:- UITableViewDelegate methods
extension InspectionVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let weld = self.spool?.welds[indexPath.row]
        if  weld?.state == .complete || weld?.state == .reject
        {
            return
        }
        weld?.isChecked = !(weld?.isChecked)!
        tableView.reloadData()
        self.showActionButtons(approveBtn: self.approveBtn, rejectBtn: self.rejectBtn)
    }
}
