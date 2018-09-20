//
//  BaseViewController.swift
//  BKI
//
//  Created by srachha on 18/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var sessionManager = AUSessionManager.shared
    var alertVC = RBAAlertController()
    let defs = UserDefaults.standard
    let bgImageview = UIImageView()
    let currentUser = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.brickRed
        bgImageview.image = UIImage.init(named: "Splash")
        bgImageview.frame = self.view.bounds
        self.view.addSubview(bgImageview)
        self.view.sendSubview(toBack: self.bgImageview)
        //self.setConstraintsForBGImageView()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //

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
    
    @IBAction func moreAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func setConstraintsForBGImageView() -> Void {
        let topConstraint = NSLayoutConstraint.init(item: self.bgImageview, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottombConstraint = NSLayoutConstraint.init(item: self.bgImageview, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint.init(item: self.bgImageview, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingbConstraint = NSLayoutConstraint.init(item: self.bgImageview, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
       
       self.view.translatesAutoresizingMaskIntoConstraints = false
   self.view.addConstraints([topConstraint,bottombConstraint,leadingConstraint,trailingbConstraint])
    }
}
