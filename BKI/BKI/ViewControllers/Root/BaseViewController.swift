//
//  BaseViewController.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController {

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var sessionManager = AUSessionManager.shared
    var alertVC = RBAAlertController()
    let defs = BKIModel.initUserdefsWithSuitName()
    let bgImageview = UIImageView()
    let currentUser = User.shared
    let httpWrapper = HTTPWrapper.sharedInstance
    var role:Int!
    var scanCode:String?
    var spool:Spool?
    var shouldRejectWholeSpool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.brickRed
        bgImageview.image = UIImage.init(named: "Splash")
        bgImageview.frame = self.view.bounds
        self.view.addSubview(bgImageview)
        self.view.sendSubview(toBack: self.bgImageview)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "backArrow"),
        style: .plain, target: self, action: #selector(self.backButtonAction(sender:)))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont.systemSemiBold15]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func backButtonAction(sender:AnyObject?) {
        UserDefaults.standard.removeObject(forKey: "truck_number")
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setScanCode(data:AVMetadataMachineReadableCodeObject?) {
        guard data != nil else {
            return
        }
        self.scanCode = data?.stringValue!.components(separatedBy: "_").last
    }
    
    @IBAction func moreAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func logoutUser() {
        let cancelClosure: () -> Void = {
            
        }
        let signoutClosure: () -> Void = {
            BKIModel.resetUserDefaults()
            self.appDelegate?.setupRootViewController()
        }
        self.alertVC.presentAlertWithTitleAndActions(actions: [cancelClosure,signoutClosure],
        buttonTitles: ["Cancel","Logout"],controller: self, message: "Are you sure you want to logout ?", title: "BKI")
    }
    
    func showScanner() {
        guard let scanNVC = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "ScanNVC",
        storyBoard: "Scanner") as? UINavigationController else { return  }
        guard let vc = scanNVC.viewControllers[0] as? ScannerViewController else { return }
        vc.delegate = self as? ScannerDelegate
        self.present(scanNVC, animated: true, completion: nil)
    }
    
    func checkLastFitting() -> Bool{
        var fittingState = 0
        if let spool = self.spool{
            for weld in spool.welds{
                if weld.state == WeldState.fitting{
                    fittingState += 1
                }
            }
        }
        if fittingState == 1{
            return true
        }
        return false
    }
    
    func checkLastWelding() -> Bool{
        var weldingState = 0
        if let spool = self.spool{
            for weld in spool.welds{
                if weld.state == WeldState.welding{
                    weldingState += 1
                }
            }
        }
        if weldingState == 1{
            return true
        }
        return false
    }
    
    func checkFittingWeldStatus() -> Bool{
        if let spool = self.spool{
            for weld in spool.welds{
                if weld.state == WeldState.fitting{
                    return true
                }
            }
        }
        return false
    }
    
    func checkWeldingWeldStatus() -> Bool{
        if let spool = self.spool{
            for weld in spool.welds{
                if weld.state == WeldState.welding{
                    return true
                }
            }
        }
        return false
    }
    
    func checkQaWeldStatus() -> Bool{
        if let spool = self.spool{
            for weld in spool.welds{
                if weld.state == WeldState.qa{
                    return true
                }
            }
        }
        return false
    }
    
    func checkHeatNumbers() -> Bool{
        if let spool = self.spool{
            for component in spool.components{
                if component.heatNumber == ""{
                    return false
                }
            }
        }
        return true
    }
    
    func rejectWelds(andUpdate tableView:UITableView, caller:String) {
        let submitClosure: () -> Void = {
            let tf = self.alertVC.rbaAlert.textFields?.first
            if (tf?.text?.count)! > 0 {
                (self.spool?.welds.count)! > 0 ? self.updateWeldsWith("reject", rejectReason: tf?.text!, isSpoolUpdate:false, updateTableView: tableView, caller: caller) : self.updateWeldsWith("rejected", rejectReason:nil, isSpoolUpdate:true, updateTableView: tableView, caller: caller)
            } else {
                self.alertVC.presentAlertWithTitleAndMessage(title: "Error", message: "Please enter reason for rejection.", controller: self)
            }
        }
        let cancelClosure: () -> Void = {
            //self.navigationController?.popViewController(animated: true)
        }
        self.alertVC.presentAlertWithInputField(actions: [cancelClosure,submitClosure], buttonTitles: ["Cancel","Submit"], controller: self, message: "A message should be a short, complete sentence.")
    }
    
    func getSelectedWeldIds() -> [Int] {
        let weldIds = self.spool?.welds.filter({ (weld) -> Bool in
            return weld.isChecked
        }).map({ (weld) -> Int in
            weld.id!
        })
        return weldIds!
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
    
    func getWeldingStateWeldIds() -> [Int] {
        let weldIds = self.spool?.welds.filter({ (weld) -> Bool in
            let bool = weld.getWeldState(state: weld.state!) == "welding" ? true:false
            return bool
        }).map({ (weld) -> Int in
            return weld.id!
        })
        return weldIds!
    }
    
    func getQaStateWeldIds() -> [Int] {
        let weldIds = self.spool?.welds.filter({ (weld) -> Bool in
            let bool = weld.getWeldState(state: weld.state!) == "qa" ? true:false
            return bool
        }).map({ (weld) -> Int in
            return weld.id!
        })
        return weldIds!
    }
    
    func resetWeldStatus() {
        for weld in (self.spool?.welds)! {
            weld.isChecked = false
        }
    }
    
    func showActionButtons(approveBtn:UIButton,rejectBtn:UIButton) {
        let isHidden = self.getSelectedWeldIds().count > 0 ? false : true
        if isHidden || !checkHeatNumbers(){
            approveBtn.alpha = 0.5
            approveBtn.isEnabled = false
        } else {
            approveBtn.alpha = 1
            approveBtn.isEnabled = true
        }
        rejectBtn.alpha = isHidden ? 0.5 : 1
        rejectBtn.isEnabled = !isHidden
    }
    
    func showRejectButton(rejectBtn:UIButton)  {
        let isHidden = self.getSelectedWeldIds().count > 0 ? false : true
        if isHidden {
            rejectBtn.alpha = 0.5
        } else {
            rejectBtn.alpha = 1
        }
        rejectBtn.isEnabled = !isHidden
    }
    
    func updateWeldsWith(_ status:String, rejectReason:String?, isSpoolUpdate:Bool,updateTableView tableView:UITableView, caller:String) {
        var weldParams = ["event":status] as [String : Any]
//        var weldIds:[Int]
//        if shouldRejectWholeSpool{
//            if 1{
//                weldIds = getWeldingStateWeldIds()
//            }else{
//                weldIds = getQaStateWeldIds()
//            }
//        }else{
//            weldIds = self.getSelectedWeldIds()
//        }
        let weldIds = shouldRejectWholeSpool ? (caller == "weld" ? self.getWeldingStateWeldIds() : getQaStateWeldIds()) : self.getSelectedWeldIds()
        
        weldParams["weld_ids"] = weldIds
        if rejectReason != nil {
            weldParams["reject_reason"] = rejectReason
        }
        self.updateSpoolStateWith(spool: self.spool!, params: weldParams as [String : AnyObject], isSpoolUpdate: isSpoolUpdate, updateTableView: tableView)
    }
    
    func textFieldDidPressNextOrPrev(next: Bool, textField: AUSessionField) {
        let currentTag = textField.tag
        let nextTF = next ? self.view.viewWithTag(currentTag+1) : self.view.viewWithTag(currentTag-1)
        textField.resignFirstResponder()
        nextTF?.becomeFirstResponder()
    }
    
}

extension UIViewController {
    
    func hideNavigationController() {
        switch type(of: self) {
        case is MainDashBoardVC.Type, is DashBoardVC.Type:
            self.navigationController?.isNavigationBarHidden = true
            return
        default:
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func showFailureAlert(with message:String) {
        DispatchQueue.main.async {
            MBProgressHUD.hideHud(view: self.view)
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateSpoolStateWith(spool:Spool, params:[String:AnyObject], isSpoolUpdate:Bool,updateTableView tableView:UITableView) {
        MBProgressHUD.showHud(view: self.view)
        var endPoint = "spools/\((spool.id)!)/welds/modify_state"
        var body = [String:AnyObject]()
        if isSpoolUpdate {
           endPoint = "spools/\((spool.id)!)/modify_state"
            body = params
        }
        else {
            body = ["weld":params as AnyObject]
        }
    HTTPWrapper.sharedInstance.performAPIRequest(endPoint, methodType: "PUT", parameters: body, successBlock: { (responseData) in
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    let welds = responseData["welds"] as? [[String:AnyObject]]
                    for weldInfo in welds! {
                        let weld = spool.welds.filter({ (weld) -> Bool in
                            return weld.id == weldInfo["id"] as? Int
                        }).first
                        weld?.saveWeld(weldInfo: weldInfo)
                        weld?.isChecked = false
                    }
                    tableView.reloadData()
                    MBProgressHUD.hideHud(view: self.view)
//                    self.navigationController?.popViewController(animated: true)
                    let previousVC = self.navigationController?.viewControllers.last as? DashBoardVC
                    previousVC?.shouldChangeState = true
                    
                    let inspectionVC = self.navigationController?.viewControllers.last as? InspectionVC
                    inspectionVC?.rejectSpoolButtonState()
                    inspectionVC?.showRejectButton(rejectBtn: (inspectionVC?.rejectBtn)!)
                    let weldStatusVC = self.navigationController?.viewControllers.last as? WeldStatusVC
                    weldStatusVC?.rejectSpoolButtonState()
                    weldStatusVC?.showRejectButton(rejectBtn: (weldStatusVC?.rejectBtn)!)
                }
            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
}

extension UITableViewController {
    
}
class BaseTableViewController: UITableViewController {
    
    var alertVC = RBAAlertController()

    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "backArrow"), style: .plain, target: self, action: #selector(self.backButtonAction(sender:)))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.systemSemiBold15]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backButtonAction(sender:AnyObject?) {
        if let vc  = self as? LoadMiscTVC {
            if vc.load.materials.count > 0 {
                for mat in vc.load.materials {
                    if mat.desc?.count == 0 || mat.quantity <= 0 {
                        self.showFailureAlert(with: "Please fill quantity and description for all materials.")
                        return
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
        let previousVC = self.navigationController?.viewControllers.last as? DashBoardVC
        previousVC?.shouldChangeState = true
    }
    
//    func showFailureAlert(with message:String) {
//        DispatchQueue.main.async {
//            MBProgressHUD.hideHud(view: self.view)
//            self.alertVC.presentAlertWithTitleAndMessage(title: "ERROR", message: message, controller: self)
//        }
//    }
}


