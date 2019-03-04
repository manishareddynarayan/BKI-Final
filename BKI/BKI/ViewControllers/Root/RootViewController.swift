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
        BKIModel.isUserLoggedIn() ? getUserDetails() : self.appDelegate?.setupRootViewController()
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
    
    func getUserDetails() {
        
        let id = BKIModel.userId()
        httpWrapper.performAPIRequest("users/\(id)", methodType: "GET",
                                      parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                BKIModel.saveUserinDefaults(info: responseData)
                self.appDelegate?.setupRootViewController()
            }
        }) { (error) in
            DispatchQueue.main.async {
                let okClosure: () -> Void = {
                    BKIModel.initUserdefsWithSuitName().set(false, forKey: "isLoggedIn")
                    self.appDelegate?.setupRootViewController()
                }
                self.alertVC.presentAlertWithTitleAndActions(actions: [okClosure],
                                                buttonTitles: ["OK"], controller: self, message:(error?.localizedDescription)! , title: "ERROR")
            }
        }
    }

}
