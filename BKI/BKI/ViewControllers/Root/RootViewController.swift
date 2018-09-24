//
//  RootViewController.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if BKIModel.isUserLoggedIn() {
            getUserDetails()
        }
        else {
            self.appDelegate?.setupRootViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getUserDetails() -> Void {
        
        let id = BKIModel.userId()
        HTTPWrapper.sharedInstance.performAPIRequest("users/\(id)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                BKIModel.saveUserinDefaults(info: responseData)
                self.appDelegate?.setupRootViewController()
            }
        }) { (error) in
            DispatchQueue.main.async {
            self.alertVC.presentAlertWithTitleAndMessage(title: "ERROR", message: error.localizedDescription, controller: self)
                BKIModel.initUserdefsWithSuitName().set(false, forKey: "isLoggedIn")
            self.appDelegate?.setupRootViewController()
            }
        }
    }

}
