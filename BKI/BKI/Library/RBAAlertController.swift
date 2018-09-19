//
//  RBAAlertController.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 17/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class RBAAlertController: NSObject {
    
    var presentController :UIViewController!
    var rbaAlert : UIAlertController!
    
    
    func initAlertController(message:String, controller:UIViewController) {
        
        self.presentController = controller
        rbaAlert = UIAlertController (title: "", message: message, preferredStyle: .alert)
    }
    
    
    func initAlertControllerWithTitle(title:String, message:String, controller:UIViewController) {
        
        self.presentController = controller
        rbaAlert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
    }
    
    
    func presentAlertWithMessage(message:String, controller:UIViewController)  {
        
        DispatchQueue.main.async() {
            self.initAlertController(message: message, controller: controller)
            let okAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            self.rbaAlert.addAction(okAction)
            self.presentController .present(self.rbaAlert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWithTitleAndMessage(title:String, message:String, controller:UIViewController)  {
        
        DispatchQueue.main.async() {
            self.initAlertControllerWithTitle(title: title, message:message , controller: controller)
            let okAction = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            self.rbaAlert.addAction(okAction)
            self.presentController .present(self.rbaAlert, animated: true, completion: nil)
        }
    }
    
    
    func presentPasswordAlert(controller:UIViewController)  {
        
        DispatchQueue.main.async() {
            self.initAlertControllerWithTitle(title: "UOVO", message: "Validation Message", controller: controller)
            self.rbaAlert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "UOVO"
            })
            let okAction = UIAlertAction (title: "SUBMIT", style: .default, handler: {(action: UIAlertAction!) in
            })
            self.rbaAlert.addAction(okAction)
            
            self.presentController.present(self.rbaAlert, animated: true, completion: nil)
        }
    }
    
    
    func presentAlertWithInputField(actions:[()->()], buttonTitles:[String],controller:UIViewController,message:String)  {
        
        DispatchQueue.main.async() {
            self.initAlertControllerWithTitle(title: "Caption", message: message, controller: controller)
            self.rbaAlert.addTextField(configurationHandler: { (textField) -> Void in
                
            })
            self.addButtons(withTitle: buttonTitles, withActions: actions)
            self.presentController.present(self.rbaAlert, animated: true, completion: nil)
        }
    }
    
    
    func presentAlertWithActions(actions:[()->()]?, buttonTitles:[String], controller:UIViewController, message:String) -> Void {
        
        DispatchQueue.main.async() {
            self.initAlertController(message: message, controller: controller)
            self.addButtons(withTitle: buttonTitles, withActions: actions)
            self.presentController.present(self.rbaAlert, animated: true, completion: nil)
        }
        
    }
    
    func addButtons(withTitle buttonTitles:[String], withActions actions:[()->()]?) -> Void {
        for (idx,title) in buttonTitles.enumerated()
        {
            if idx == 0 {
                let buttonAction = UIAlertAction (title: title, style: .cancel, handler: {(action: UIAlertAction!) in
                    let action = actions?[idx]
                    action!()
                })
                self.rbaAlert.addAction(buttonAction)
                
            }
            else {
                let buttonAction = UIAlertAction (title: title, style: .default, handler: {(action: UIAlertAction!) in
                    let action = actions?[idx]
                    action!()
                })
                self.rbaAlert.addAction(buttonAction)
            }
        }
    }
    
    func presentAlertWithTitleAndActions(actions:[()->()], buttonTitles:[String], controller:UIViewController, message:String, title:String) -> Void {
        
        DispatchQueue.main.async() {
            self.initAlertControllerWithTitle(title: title, message: message, controller: controller)
            self.addButtons(withTitle: buttonTitles, withActions: actions)
            self.presentController.present(self.rbaAlert, animated: true, completion: nil)
        }
        
    }
}
