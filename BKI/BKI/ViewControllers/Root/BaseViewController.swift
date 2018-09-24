//
//  BaseViewController.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var sessionManager = AUSessionManager.shared
    var alertVC = RBAAlertController()
    let defs = BKIModel.initUserdefsWithSuitName()
    let bgImageview = UIImageView()
    let currentUser = User.shared
    let httpWrapper = HTTPWrapper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.brickRed
        bgImageview.image = UIImage.init(named: "Splash")
        bgImageview.frame = self.view.bounds
        self.view.addSubview(bgImageview)
        self.view.sendSubview(toBack: self.bgImageview)
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNavigationController() {
        switch type(of: self) {
        case is MainDashBoardVC.Type, is DashBoardVC.Type:
            self.navigationController?.isNavigationBarHidden = true
            return
        default:
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        self.alertVC.presentAlertWithTitleAndActions(actions: [cancelClosure,signoutClosure], buttonTitles: ["Cancel","Logout"], controller: self, message: "Are you sure you want to logout ?", title: "BKI")
    }
    
    func showScanner() {
        guard let scanNVC = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "ScanNVC", storyBoard: "Scanner") as? UINavigationController else { return  }
        guard let vc = scanNVC.viewControllers[0] as? ScannerViewController else { return  }
        
        vc.delegate = self as! ScannerDelegate
        
        self.present(scanNVC, animated: true, completion: nil)
    }
    
}
