//
//  LoginVC.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var emailTF: AUTextField!
    @IBOutlet weak var passwordTF: AUPasswordField!
    @IBOutlet weak var appVersionLbl: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        emailTF.designToolBarWithNext(isNext: true, withPrev: false, delegate: self)
        passwordTF.designToolBarWithNext(isNext: false, withPrev: true, delegate: self)
        
        if let username = UserDefaults.standard.string(forKey: "recentUsername")
        {
            emailTF.text = username
        }
        appVersionLbl.text = "App version \(AboutItem().version ?? "") (\(AboutItem().build ?? ""))"
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.sessionManager.requiredFields = [["Field":emailTF as Any,"Key":"Email"],
                                              ["Field":passwordTF as Any,"Key":"Password"]] as [[String : AnyObject]]
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
     //MARK:- IBActions
    @IBAction func signInAction(_ sender: Any)
    {
//        let dict = self.sessionManager.validateRequiredFields()
//        if dict != nil {
//            if let error = dict!["Error"] as? String {
//                self.alertVC.presentAlertWithTitleAndMessage(title: "ERROR", message: error , controller: self)
//                return
//            }
//        }
        UserDefaults.standard.set(emailTF.text!, forKey: "recentUsername")
        
        MBProgressHUD.showHud(view: self.view)

        let loginParams = ["email":emailTF.text!,"password":passwordTF.text!,"platform":"mobile"]
        httpWrapper.performAPIRequest("users/sign_in", methodType: "POST", parameters: loginParams as [String : AnyObject], successBlock: { (responseData) in
                DispatchQueue.main.async {
                    BKIModel.saveUserinDefaults(info: responseData)
                    self.appDelegate?.setupRootViewController()
                    MBProgressHUD.hideHud(view: self.view)

                }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    @IBAction func forgotMyPasswordAction(_ sender: Any) {
        
    }
}

//MARK:- UItextField Input Delegate
extension LoginVC : TextInputDelegate
{
    func textFieldDidPressedNextButton(_ textField: AUSessionField)
    {
        let currentTag = textField.tag
        let nextTF = self.view.viewWithTag(currentTag+1)
        textField.resignFirstResponder()
        nextTF?.becomeFirstResponder()
    }
    
    func textFieldDidPressedPreviousButton(_ textField: AUSessionField)
    {
        let currentTag = textField.tag
        let prevTF = self.view.viewWithTag(currentTag-1)
        textField.resignFirstResponder()
        prevTF?.becomeFirstResponder()
        
    }
    
    func textFieldDidPressedDoneButton(_ textField: AUSessionField)
    {
        textField.resignFirstResponder()
    }
}
