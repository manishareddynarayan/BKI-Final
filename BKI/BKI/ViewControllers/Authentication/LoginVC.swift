//
//  LoginVC.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController,UITextFieldDelegate,TextInputDelegate {

    @IBOutlet weak var passwordTF: AUPasswordField!
    @IBOutlet weak var emailTF: AUTextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.designToolBarWithNext(isNext: true, withPrev: false, delegate: self)
        passwordTF.designToolBarWithNext(isNext: false, withPrev: true, delegate: self)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sessionManager.requiredFields = [["Field":emailTF,"Key":"Email"],["Field":passwordTF,"Key":"Password"]] as [[String : AnyObject]]
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
    
    @IBAction func signInAction(_ sender: Any) {
        
        let dict = self.sessionManager.validateRequiredFields()
        if dict != nil {
            self.alertVC.presentAlertWithTitleAndMessage(title: "ERROR", message: dict!["Error"] as! String , controller: self)
            return
        }
        print("validation success")
        let defs = UserDefaults.standard
        defs.set(true, forKey: "isLoggedIn")
        self.appDelegate?.setupRootViewController(isSignup: false)
       // MBProgressHUD.showHud(view: self.view)

    }
    
    @IBAction func forgotMyPasswordAction(_ sender: Any) {
        
    }
    
    
    
    //MARK:UItextField Input Delegate
    
    func textFieldDidPressedNextButton(_ textField: AUSessionField) {
        let currentTag = textField.tag
        let nextTF = self.view.viewWithTag(currentTag+1)
        textField.resignFirstResponder()
        nextTF?.becomeFirstResponder()
    }
    
    func textFieldDidPressedPreviousButton(_ textField: AUSessionField) {
        let currentTag = textField.tag
        let prevTF = self.view.viewWithTag(currentTag-1)
        textField.resignFirstResponder()
        prevTF?.becomeFirstResponder()
        
    }
    
    func textFieldDidPressedDoneButton(_ textField: AUSessionField) {
        
        textField.resignFirstResponder()
    }
}
