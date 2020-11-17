//
//  BaseViewController.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import AVFoundation
import Starscream


class BaseViewController: UIViewController,WebSocketDelegate {
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var sessionManager = AUSessionManager.shared
    var alertVC = RBAAlertController()
    let defs = BKIModel.initUserdefsWithSuitName()
    let bgImageview = UIImageView()
    let currentUser = User.shared
    let httpWrapper = HTTPWrapper.sharedInstance
    var role:Int!
    var scanCode:String?
    var scanItem:String?
    var spool:Spool?
    var hanger:Hanger?
    var evolve:Evolve?
    var shouldRejectWholeSpool = false
    var socket:WebSocket?
    var isConnected = false
    var trackerId: Int?
    var trackerIds: [Int] = []
    var loginUser:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brickRed
        bgImageview.image = UIImage.init(named: "Splash")
        bgImageview.frame = self.view.bounds
        self.view.addSubview(bgImageview)
        self.view.sendSubviewToBack(self.bgImageview)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "backArrow"),
                                                                     style: .plain, target: self, action: #selector(self.backButtonAction(sender:)))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont.systemSemiBold15]
        self.createSocketRequest(loginUser: nil)
    }
    //    after connecting - user already login uh ani check cheyali
    //    if yes - show pop - should we delete him from other - if yes - call stop tracking
    func createSocketRequest(loginUser:User?) {
        if defs?.object(forKey: "access-token") != nil {
            if loginUser != nil {
                self.loginUser = loginUser
            }
            let token = (defs?.object(forKey: "access-token") as? String)!
            let request = URLRequest(url: URL(string: "ws://390078573d81.ngrok.io/cable?X_ACCESS_TOKEN:\(token)")!)
            socket = WebSocket(request: request)
            socket?.delegate = self
            socket?.disconnect()
            socket?.connect()
        }
    }
    
    func createChannel()
    {
        let strChannel = "{ \"channel\": \"IosUsersChannel\" }"
        let message = ["command" : "subscribe","identifier": strChannel]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: message)
            if let dataString = String(data: data, encoding: .utf8){
                self.socket?.write(string: dataString)
            }
//            let loginUser = UserDefaults.standard.data(forKey: "loginUser") as? User
            if loginUser != nil {
                if self.loginUser?.alreadyLoggedIn ?? false {
                        let noClosure: () -> Void = {
                            BKIModel.resetUserDefaults()
                            self.appDelegate?.setupRootViewController()
                        }
                        let yesClosure: () -> Void = {
                            self.stopUserTrackingWebSocket(withUdid: true, userId: self.currentUser.id ?? 0) { (sucess) in
                                self.appDelegate?.setupRootViewController()
                            } failBlock: { (error) in
                                DispatchQueue.main.async {
                                    MBProgressHUD.hideHud(view: self.view)
                                    self.showFailureAlert(with: (error?.localizedDescription)!)
                                }
                            }
                        }
                        self.alertVC.presentAlertWithTitleAndActions(actions: [yesClosure,noClosure],
                                                                     buttonTitles: ["Yes","No"],controller: self, message: "This user is working in some other place. So you want to log him out from there?", title: "BKI")
                } else {
                    self.appDelegate?.setupRootViewController()
                }
            }
//                alert yes- stop tracking No- return back to login
                //
        } catch {
            print("JSON serialization failed: ", error)
        }
    }
    
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            self.createChannel()
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            guard let data = string.data(using: .utf8), let devicedata = try? JSONDecoder().decode(deviceData.self, from: data) else {
                print("could decode")
                return
            }
            print("\(devicedata.message.primary_user_id)")
            print("\(devicedata.message.udid)")
            if (devicedata.message.udid != nil ){
                if(String(self.currentUser.id ?? 0) == devicedata.message.primary_user_id && UIDevice.current.identifierForVendor!.uuidString != devicedata.message.udid) {
                    BKIModel.resetUserDefaults()
                    self.appDelegate?.setupRootViewController()
                }
            } else if (devicedata.message.secondary_user_id != nil) {
                if let additionalUsers = UserDefaults.standard.array(forKey: "additional_users") {
                    UserDefaults.standard.set(additionalUsers.filter({String(($0 as? Int)!) != devicedata.message.secondary_user_id}), forKey: "additional_users")
                    if let topVC = UIApplication.getTopViewController() {
                        topVC.viewDidLoad()
//                        topVC.viewWillAppear(false)
                    }
//                    let vc = navigationController?.viewControllers.last
//                    vc?.viewDidLoad()
                }
                // remove additional users
            } else if (devicedata.message.primary_user_id != nil) {
                if(String(self.currentUser.id ?? 0) == devicedata.message.primary_user_id) {
                    BKIModel.resetUserDefaults()
                    self.appDelegate?.setupRootViewController()
                }
            }
//            if(devicedata.message.udid != nil){
//                    if(current_user.id === user_id && udid != current_user_udid) { logout(user_id) - remove from defaults }
//                {
//
//            remove_secondary_id - in some other phone - remove this id from additional users if he is on action screens
//        } else (primary_user_id){
//            logout(primary_user_id)
//        just remove from defaults
//        }
            
            case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
        }
    }
    
    func stopUserTrackingWebSocket(withUdid:Bool,userId:Int,successBlock:@escaping (Bool) -> (),failBlock:@escaping (NSError?) -> ()) {
        MBProgressHUD.showHud(view: self.view)
        let udid = UIDevice.current.identifierForVendor!.uuidString
        let url = withUdid ? "user_time_logs/stop_tracking?user_id=\(userId)&websocket=true&udid=\(udid)" : "user_time_logs/stop_tracking?user_id=\(userId)&websocket=true"
        self.httpWrapper.performAPIRequest(url, methodType: "PUT", parameters: nil) { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                print(responseData)
                successBlock(true)
            }
        } failBlock: { (error) in
            MBProgressHUD.hideHud(view: self.view)
            failBlock(error)
        }
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
        guard (data?.stringValue!.contains(":") ?? false) else {
            self.scanItem = "Spool"
            self.scanCode = data?.stringValue ?? ""
            return
        }
        let fullString = data?.stringValue!.split(separator: ":")
        self.scanItem = String((fullString?[0])!)
        self.scanCode = String((fullString?[1])!).trimmingCharacters(in: .whitespaces)//.components(separatedBy: "_").last
    }
    
    @IBAction func moreAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func logoutUser() {
        let cancelClosure: () -> Void = {
            
        }
        let signoutClosure: () -> Void = {
            self.stopUserTracking { (sucess) in
                BKIModel.resetUserDefaults()
                self.appDelegate?.setupRootViewController()
            } failBlock: { (error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hideHud(view: self.view)
                    self.showFailureAlert(with: (error?.localizedDescription)!)
                }
            }
        }
        self.alertVC.presentAlertWithTitleAndActions(actions: [cancelClosure,signoutClosure],
                                                     buttonTitles: ["Cancel","Logout"],controller: self, message: "Are you sure you want to logout ?", title: "BKI")
    }
    
    func stopUserTracking(successBlock:@escaping (Bool) -> (),failBlock:@escaping (NSError?) -> ()) {
        MBProgressHUD.showHud(view: self.view)
        self.httpWrapper.performAPIRequest("user_time_logs/stop_tracking?user_id=\(self.currentUser.id ?? 0)", methodType: "PUT", parameters: nil) { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                print(responseData)
                successBlock(true)
            }
        } failBlock: { (error) in
            failBlock(error)
        }
    }
    
    func getConditionsForAdditionalUsers(withRole role:Int,successBlock:@escaping (Bool) -> ()) {
        if let selectedState = UserDefaults.standard.string(forKey: "selectedState") {
            if let additionalUsers = UserDefaults.standard.array(forKey: "additional_users") {
                if User.getRoleName(userRole: role) != selectedState && additionalUsers.count > 0 {
                    let yesClosure: () -> Void = {
                        self.stopUserTracking { (sucess) in
                            UserDefaults.standard.removeObject(forKey: "additional_users")
                            successBlock(true)
                        } failBlock: { (error) in
                            DispatchQueue.main.async {
                                MBProgressHUD.hideHud(view: self.view)
                                self.showFailureAlert(with: (error?.localizedDescription)!)
                            }
                        }
                    }
                    let noClosure: () -> Void = {
                        self.stopUserTracking { (sucess) in
                            print(sucess)
                            successBlock(true)
                        } failBlock: { (error) in
                            DispatchQueue.main.async {
                                MBProgressHUD.hideHud(view: self.view)
                                self.showFailureAlert(with: (error?.localizedDescription)!)
                            }
                        }
                    }
                    let buttonTitles = ["Yes","No"]
                    self.alertVC.presentAlertWithActions(actions:  [yesClosure,noClosure], buttonTitles: buttonTitles, controller: self, message: "Do you want to remove the additional users already present?")
                } else {
                    successBlock(true)
                }
            } else {
                successBlock(true)
            }
        } else {
            successBlock(true)
        }
    }
    
    
    func showScanner() {
        self.scanCode = ""
        self.trackerId = nil
        guard let scanNVC = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "ScanNVC",
                                                                              storyBoard: "Scanner") as? UINavigationController else { return  }
        guard let vc = scanNVC.viewControllers[0] as? ScannerViewController else { return }
        vc.delegate = self as? ScannerDelegate
        scanNVC.modalPresentationStyle = .fullScreen
        self.present(scanNVC, animated: true, completion: nil)
    }
    
    func checkLastFitting() -> Bool{
        var fittingState = 0
        if let spool = self.spool{
            for weld in spool.welds{
                fittingState = weld.state == WeldState.fitting ? (fittingState + 1) : fittingState
                //                if weld.state == WeldState.fitting{
                //                    fittingState += 1
                //                }
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
                weldingState = weld.state == WeldState.welding ? (weldingState + 1) : weldingState
                //                if weld.state == WeldState.welding{
                //                    weldingState += 1
                //                }
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
    
    func checkHeatNumbersWithSpool(spool: Spool) -> Bool{
        for component in spool.components{
            if component.heatNumber == ""{
                return false
            }
        }
        return true
    }
    
    func rejectWelds(andUpdate tableView:UITableView, caller:String) {
        let submitClosure: () -> Void = {
            let tf = self.alertVC.rbaAlert.textFields?.first
            if !((tf?.text?.isEmpty)!) {
                !((self.spool?.welds.isEmpty)!) ? self.updateWeldsWith("reject", rejectReason: tf?.text!, isSpoolUpdate:false, updateTableView: tableView, caller: caller, odTestMethodsWelds: nil, idTestMethodsWelds: nil) : self.updateWeldsWith("rejected", rejectReason:nil, isSpoolUpdate:true, updateTableView: tableView, caller: caller, odTestMethodsWelds: nil, idTestMethodsWelds: nil)
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
        if !((self.spool?.welds.isEmpty)!) {
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
        let isHidden = (self.getSelectedWeldIds().isEmpty)
        if isHidden {
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
        let isHidden = (self.getSelectedWeldIds().isEmpty)
        rejectBtn.alpha = isHidden ? 0.5 : 1
        rejectBtn.isEnabled = !isHidden
    }
    
    func updateWeldsWith(_ status:String, rejectReason:String?, isSpoolUpdate:Bool,updateTableView tableView:UITableView, caller:String, odTestMethodsWelds :[String:([String:String])]?, idTestMethodsWelds :[String:([String:String])]?) {
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
        weldParams["id_test_method_welds"] = idTestMethodsWelds
        weldParams["od_test_method_welds"] = odTestMethodsWelds
        if rejectReason != nil {
            weldParams["reject_reason"] = rejectReason
        }
        self.updateSpoolStateWith(spool: self.spool!, params: weldParams as [String : AnyObject], isSpoolUpdate: isSpoolUpdate, updateTableView: tableView)
    }
    
    func startTracker(with id:Int, atShipping:Bool) {
        var timeLogsData : [String:([String:Any])] = [String: [String:Int]]()
        let addUsers = UserDefaults.standard.array(forKey: "additional_users")
        timeLogsData["0"] = ["user_id":currentUser.id!]
        var count = 1
        if addUsers != nil {
            for user in addUsers! {
                let data = ["user_id":user,"primary_user_id":currentUser.id!]
                timeLogsData["\(count)"] = data
                if count <= addUsers?.count ?? 0 {
                    count += 1
                }
            }
        }
        //        "worked_on_type" - spool ki fabrication
        //
        let state = atShipping ? "ready_to_ship" : self.scanItem == "Hanger" ? "fabrication"  : role == 1 ? "fitting" : role == 2 ? "welding" : role == 4 ? "qa" : ""
        let trakerParams = ["state":state,"worked_on_id":id as Any,"worked_on_type": (atShipping && self.scanItem == "Spool" ? "Fabrication" : self.scanItem as Any),"user_time_logs_attributes":timeLogsData] as [String : Any]
        let params = ["activity_tracker":trakerParams] as [String:AnyObject]
        MBProgressHUD.hideHud(view: self.view)
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("activity_trackers", methodType: "POST", parameters: params) { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                MBProgressHUD.hideHud(view: self.view)
                if let id = responseData["id"] as? Int{
                    let vc = self.navigationController?.viewControllers.last as? PackageViewController
                    vc?.trackerId = id
                    self.trackerId = id
                    if atShipping {
                        self.trackerIds.append(id)
                        UserDefaults.standard.set(self.trackerIds, forKey: "trackerIdsArray")
                    }
                }
            }
        } failBlock: { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
        
    }
    func stopTracking() {
        let params = ["stop_tracking":true] as [String:AnyObject]
        httpWrapper.performAPIRequest("activity_trackers/\(self.trackerId ?? 0)", methodType: "PUT", parameters: params) { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                UserDefaults.standard.removeObject(forKey: "activity_tracker_ids")
                self.trackerIds.removeAll()
            }
        } failBlock: { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
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
        var mutableParams = params
        let event = mutableParams["event"]
        mutableParams.removeValue(forKey: "event")
        if isSpoolUpdate {
            endPoint = "spools/\((spool.id)!)/modify_state"
            body = ["event":event!, "weld":mutableParams as AnyObject]
        }
        else {
            if let IDTestWeldsMethod = mutableParams["id_test_method_welds"],let ODTestWeldsMethod = mutableParams["od_test_method_welds"]{
                mutableParams.removeValue(forKey: "id_test_method_welds")
                mutableParams.removeValue(forKey: "od_test_method_welds")
                body = ["event":event!,"id_test_method_welds":IDTestWeldsMethod,"od_test_method_welds":ODTestWeldsMethod,"weld":mutableParams as AnyObject]
            }else{
                body = ["event":event!,"weld":params as AnyObject]
            }
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
                    inspectionVC?.showActionButtons(approveBtn: (inspectionVC?.approveBtn)!, rejectBtn: (inspectionVC?.rejectBtn)!)
                    
                    //                    inspectionVC?.showRejectButton(rejectBtn: (inspectionVC?.rejectBtn)!)
                    let weldStatusVC = self.navigationController?.viewControllers.last as? WeldStatusVC
                    weldStatusVC?.rejectSpoolButtonState()
                    weldStatusVC?.showRejectButton(rejectBtn: (weldStatusVC?.rejectBtn)!)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemSemiBold15]
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
            if !(vc.load.materials.isEmpty) {
                for mat in vc.load.materials {
                    if (mat.desc?.isEmpty)! || mat.quantity <= 0 {
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
}
struct Device:Decodable {
    let udid:String?
    let primary_user_id:String?
    let secondary_user_id:String?
}
struct deviceData:Decodable {
    let message:Device
}
extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}


