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
    
    func loogoutUser() {
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
    
    func updateSpoolStateWith(spool:Spool, params:[String:AnyObject], isSpoolUpdate:Bool) {
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
                print(responseData)
                DispatchQueue.main.async {
                    let welds = responseData["welds"] as? [[String:AnyObject]]
                    for weldInfo in welds! {
                        let weld = spool.welds.filter({ (weld) -> Bool in
                            return weld.id == weldInfo["id"] as? Int
                        }).first
                        weld?.saveWeld(weldInfo: weldInfo)
                    }
                    MBProgressHUD.hideHud(view: self.view)
                    self.navigationController?.popViewController(animated: true)
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
                    if mat.desc.count == 0 || mat.quantity <= 0 {
                        self.showFailureAlert(with: "Please fill quantity and description for all materials.")
                        return
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
//    func showFailureAlert(with message:String) {
//        DispatchQueue.main.async {
//            MBProgressHUD.hideHud(view: self.view)
//            self.alertVC.presentAlertWithTitleAndMessage(title: "ERROR", message: message, controller: self)
//        }
//    }
}


