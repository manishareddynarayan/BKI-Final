//
//  EvolveViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 22/09/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class EvolveViewController: BaseViewController {

    @IBOutlet weak var qaView: UIView!
    @IBOutlet weak var fitupView: UIView!
    @IBOutlet weak var rejectReasonLabel: UILabel!
    @IBOutlet weak var rejectReasonTitleLabel: UILabel!
    @IBOutlet weak var batteryNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        batteryNameLabel.text = self.evolve?.batteryName
        rejectReasonLabel.text = self.evolve?.rejectReason
//        if self.role == 4 {
//            fitupView.isHidden = true
//            qaView.isHidden = false
//        } else {
//            fitupView.isHidden = false
//            qaView.isHidden = true
//        }
        if self.evolve?.rejectReason == nil {
            rejectReasonLabel.isHidden = true
            rejectReasonTitleLabel.isHidden = true
        }
        if self.role == 1 && evolve?.evolveState == "fitting" {
            fitupView.isHidden = false
        } else if self.role == 4 && evolve?.evolveState == "qa" {
            qaView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func fitUpApprove(_ sender: Any) {
        let params = ["state":"qa" as AnyObject]
        performAPIRequest(params: params)
    }
    
    @IBAction func qaReject(_ sender: Any) {
        var rejectReason:String?
        let submitClosure: () -> Void = {
            let tf = self.alertVC.rbaAlert.textFields?.first
            if !((tf?.text?.isEmpty)!) {
                rejectReason = tf?.text
                var params = [String:AnyObject]()
                params["state"] = "fitting" as AnyObject
                params["reject_reason_attributes"] = ["content":rejectReason] as AnyObject
                self.performAPIRequest(params: params)
            } else {
                self.alertVC.presentAlertWithTitleAndMessage(title: "Error", message: "Please enter reason for rejection.", controller: self)
                return
            }
        }
        let cancelClosure: () -> Void = {
            //self.navigationController?.popViewController(animated: true)
        }
        self.alertVC.presentAlertWithInputField(actions: [cancelClosure,submitClosure], buttonTitles: ["Cancel","Submit"], controller: self, message: "A message should be a short, complete sentence.")
    }
    
    @IBAction func qaAccept(_ sender: Any) {
        let params = ["state":"ready_to_ship" as AnyObject]
        performAPIRequest(params: params)
    }
    
    func performAPIRequest(params:[String:AnyObject]) {
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("packages/\(evolve?.packageId ?? 0)/evolve_fabrications/\(evolve!.id ?? 0)", methodType: "PUT", parameters: ["package_material":params as AnyObject]) { (responseData) in
            DispatchQueue.main.async {
            MBProgressHUD.hideHud(view: self.view)
            self.popViewController()
            print(responseData)
            }
        } failBlock: { (error) in
            DispatchQueue.main.async {
            MBProgressHUD.hideHud(view: self.view)
            self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
}
