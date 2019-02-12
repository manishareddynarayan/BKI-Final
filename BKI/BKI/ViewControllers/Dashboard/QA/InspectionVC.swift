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
    var shouldRejectWholeSpool = false
    
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
        self.showActionButtons()
        self.tableView.reloadData()
        if self.spool?.welds.count == 0 {
            self.tableView.isHidden = true
            rejectBtn.isEnabled = true
            rejectBtn.alpha = 1
            approveBtn.isEnabled = true
            approveBtn.alpha = 1
//            self.actionView.isHidden = false
//            self.actionView.isHidden = false
        }
    }
    
    func getSelectedWeldIds() -> [Int] {
        let weldIds = self.spool?.welds.filter({ (weld) -> Bool in
            return weld.isChecked
        }).map({ (weld) -> Int in
            weld.id!
        })
        return weldIds!
    }
    
    func resetWeldStatus() {
        for weld in (self.spool?.welds)! {
            weld.isChecked = false
        }
    }
    
    func getAllWeldIds() -> [Int] {
        var weldIds:[Int] = []
        if (self.spool?.welds.count)! > 0 {
            for weld in (self.spool?.welds)! {
                weldIds.append(weld.id!)
            }
        }
        return weldIds
    }
    
    func showActionButtons() {
        let isHidden = self.getSelectedWeldIds().count > 0 ? false : true
        if isHidden {
            approveBtn.alpha = 0.5
            rejectBtn.alpha = 0.5
        } else {
            approveBtn.alpha = 1
            rejectBtn.alpha = 1
        }
        approveBtn.isEnabled = !isHidden
        rejectBtn.isEnabled = !isHidden
//        self.actionView.isHidden = isHidden
    }
    
    @IBAction func approveWeldsAction(_ sender: Any) {
        if (self.spool?.welds.count)! > 0 {
            self.updateWeldsWith("verify", rejectReason: nil, isSpoolUpdate:false)
        }
        else {
            self.updateWeldsWith("accepted", rejectReason: nil, isSpoolUpdate:true)
        }
    }
    
    @IBAction func rejectWeldsAction(_ sender: Any) {
        shouldRejectWholeSpool = false
        rejectWelds()
    }
    
    @IBAction func rejectWholeSpool(_ sender: Any) {
        shouldRejectWholeSpool = true
        rejectWelds()
    }
    
    func updateWeldsWith(_ status:String, rejectReason:String?, isSpoolUpdate:Bool) {
        var weldParams = ["event":status] as [String : Any]
        let weldIds = shouldRejectWholeSpool ? self.getAllWeldIds() : self.getSelectedWeldIds()
        weldParams["weld_ids"] = weldIds
        if rejectReason != nil {
            weldParams["reject_reason"] = rejectReason
        }
        self.updateSpoolStateWith(spool: self.spool!, params: weldParams as [String : AnyObject], isSpoolUpdate: isSpoolUpdate)
        
        // self.updateSpoolStateWith(spool: self.spool!, params: weldParams as [String : AnyObject])
        //        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)/welds/modify_state", methodType: "PUT", parameters: ["weld":weldParams as AnyObject], successBlock: { (responseData) in
        //            DispatchQueue.main.async {
        //                let welds = responseData["welds"] as? [[String:AnyObject]]
        //                for weldInfo in welds! {
        //                   let weld = self.spool?.welds.filter({ (weld) -> Bool in
        //                        return weld.id == weldInfo["id"] as? Int
        //                    }).first
        //                    weld?.saveWeld(weldInfo: weldInfo)
        //                }
        //                MBProgressHUD.hideHud(view: self.view)
        //            }
        //        }) { (error) in
        //            self.showFailureAlert(with: (error?.localizedDescription)!)
        //            self.tableView.reloadData()
        //        }
        
    }
    
    func rejectWelds() {
        let submitClosure: () -> Void = {
            let tf = self.alertVC.rbaAlert.textFields?.first
            if (tf?.text?.count)! > 0 {
                if (self.spool?.welds.count)! > 0 {
                    // self.updateWeldsWith("reject", rejectReason:tf?.text!)//
                    self.updateWeldsWith("reject", rejectReason: tf?.text!, isSpoolUpdate:false)
                }
                else {
                    self.updateWeldsWith("rejected", rejectReason:nil, isSpoolUpdate:true)
                }
            } else {
                self.alertVC.presentAlertWithTitleAndMessage(title: "Error", message: "Please enter reason for rejection.", controller: self)
            }
        }
        let cancelClosure: () -> Void = {
            //self.navigationController?.popViewController(animated: true)
        }
        self.alertVC.presentAlertWithInputField(actions: [cancelClosure,submitClosure], buttonTitles: ["Cancel","Submit"], controller: self, message: "A message should be a short, complete sentence.")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.spool?.welds.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inspectionCell") as? InspectionCell
        let weld = self.spool?.welds[indexPath.row]
        cell?.configureWeld(weld: weld!)
        cell?.selectionChangeddBlock = { (isChecked) in
            weld?.isChecked = isChecked
            tableView.reloadData()
            self.showActionButtons()
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
        self.showActionButtons()
    }
}
