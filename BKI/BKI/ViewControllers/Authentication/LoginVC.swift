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
    @IBOutlet weak var appVersionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.designToolBarWithNext(isNext: true, withPrev: false, delegate: self)
        passwordTF.designToolBarWithNext(isNext: false, withPrev: true, delegate: self)
        
        if let username = UserDefaults.standard.string(forKey: "recentUsername"){
            emailTF.text = username
        }
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        appVersionLbl.text = "App version " + appVersion! + "("
            + buildVersion! + ")"
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
        
        UserDefaults.standard.set(emailTF.text!, forKey: "recentUsername")
        MBProgressHUD.showHud(view: self.view)
        let loginParams = ["email":emailTF.text!,"password":passwordTF.text!,"platform":"mobile"]
        httpWrapper.performAPIRequest("users/sign_in", methodType: "POST", parameters: loginParams as [String : AnyObject], successBlock: { (responseData) in
                DispatchQueue.main.async {
                    let loginUser = BKIModel.saveUserinDefaults(info: responseData)
                    if BKIModel.userRole() == "qa" || BKIModel.userRole() == "fabrication" {
                        self.createSocketRequest(loginUser: loginUser)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.timeZone = TimeZone(abbreviation: "EST")
                        let dd = Date().endOfDay
//                        let todayAt12PM = calendar.date(bySettingHour: 12, minute: 16, second: 1, of: nowDateValue, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)
                        let yourDate = formatter.string(from: dd!)
                        let alarmDate = formatter.date(from: yourDate)
                        let timer = Timer(fire: alarmDate!, interval: 0, repeats: false) { (timer) in
                            self.runCode()
                        }
                        RunLoop.main.add(timer, forMode: .common)
                    } else {
                        self.alertVC.presentAlertWithMessage(message: "Please login as a Fabrication or QA user", controller: self)
                    }
                    // alerady logged - stop tracking
                    MBProgressHUD.hideHud(view: self.view)
                }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
     func runCode() {
        //to logout at 12
//        BKIModel.resetUserDefaults()
//        self.appDelegate?.setupRootViewController()
        let now = NSDate()
        let nowDateValue = now as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nowDateValue)
        let fullMinuteDate = calendar.date(from: components)!
        let date = Date().getEndOfTheDay()
        let currentDate = dateFormatter.string(from: fullMinuteDate)
        let finalAlarmDate = dateFormatter.string(from: date)
        if currentDate == finalAlarmDate {
            print("------ yes  -----")
        }
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
