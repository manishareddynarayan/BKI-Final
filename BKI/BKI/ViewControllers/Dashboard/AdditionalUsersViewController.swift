//
//  AdditionalUsersViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 08/10/20.
//  Copyright © 2020 srachha. All rights reserved.

import UIKit

class AdditionalUsersViewController: BaseViewController,TextInputDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var additionalUsersTF: AUTextField!
    @IBOutlet weak var crossButton: UIButton!
    var allAdditionalUsers = [AdditionalUser]()
    var addedUsers = [User]()
    var isUserSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.register(UINib(nibName: "LoadCell", bundle: nil), forCellReuseIdentifier: "loadCell")
        //        self.usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "materialCell")
        self.additionalUsersTF.textAlignment = .left
        self.additionalUsersTF.textColor = UIColor.white
        self.additionalUsersTF.delegate = self
        self.usersTableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        crossButton.isHidden = true
        getItemAddedUsers()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func crossButtonOnClick(_ sender: Any) {
        self.reSetSearchField()
        self.usersTableView.reloadData()
    }
    
    func reSetSearchField() {
        isUserSearch = false
        additionalUsersTF.text = ""
        crossButton.isHidden = true
        self.view.endEditing(true)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func getAdditionalUsersWithSearch(text:String?) {
        MBProgressHUD.showHud(view: self.view)
        let endPoint = text?.isEmpty ?? true ? "users/additional_users_list" :  "users/additional_users_list?search=\(text ?? "")"
        HTTPWrapper.sharedInstance.performAPIRequest(endPoint,
                                                     methodType: "GET", parameters: nil, successBlock: { (responseData) in
                                                        DispatchQueue.main.async {
                                                            MBProgressHUD.hideHud(view: self.view)
                                                            self.allAdditionalUsers.removeAll()
                                                            let additionalUsers = responseData["users"] as? [[String:AnyObject]]
                                                            for user in additionalUsers! {
                                                                let additionalUser = AdditionalUser.init(info: user)
                                                                self.allAdditionalUsers.append(additionalUser)
                                                            }
                                                            self.allAdditionalUsers.removeAll { (user) -> Bool in
                                                                self.addedUsers.map({$0.id}).contains(user.id)
                                                            }
                                                            self.usersTableView.reloadData()
                                                        }
                                                     }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    func getItemAddedUsers() {
        MBProgressHUD.showHud(view: self.view)
        HTTPWrapper.sharedInstance.performAPIRequest("activity_trackers/\(self.trackerId ?? 0)",
                                                     methodType: "GET", parameters: nil, successBlock: { (responseData) in
                                                        DispatchQueue.main.async {
                                                            MBProgressHUD.hideHud(view: self.view)
                                                            self.addedUsers.removeAll()
                                                            let additionalUsers = responseData["user_time_logs"] as? [[String:AnyObject]]
                                                            for user in additionalUsers! {
                                                                let additionalUser = User.init(info: user)
                                                                self.addedUsers.append(additionalUser)
                                                            }
                                                            self.addedUsers = self.addedUsers.filter({ (user) -> Bool in
                                                                user.id != self.currentUser.id
                                                            })
                                                            UserDefaults.standard.set(self.addedUsers.map({$0.id}), forKey: "additional_users")
                                                            self.reSetSearchField()
                                                            self.usersTableView.reloadData()
                                                        }
                                                     }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: TextInput Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == additionalUsersTF {
            isUserSearch = true
            crossButton.isHidden = false
            getAdditionalUsersWithSearch(text: "")
            return
        }
        isUserSearch = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn
                    range: NSRange, replacementString string: String) -> Bool {
        if textField == additionalUsersTF {
            //            searchTF.text = text
            isUserSearch = true
            var searchStr = textField.text! + string
            if !(searchStr.isEmpty) {
                searchStr = string.isEmpty ? String(searchStr.dropLast()) : searchStr
                crossButton.isHidden = false
                self.getAdditionalUsersWithSearch(text: searchStr)
            }
            return true
        }
        isUserSearch = false
        return true
    }
}
extension AdditionalUsersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUserSearch {
            return !(self.allAdditionalUsers.isEmpty) ? self.allAdditionalUsers.count : 0
        }
        return addedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as? LoadCell
        let user = isUserSearch ? self.allAdditionalUsers[indexPath.row] : self.addedUsers[indexPath.row]
        cell?.viewDrawingBtn.isHidden = true
        cell?.isoButton.isHidden = true
        cell?.deleteSpoolButton.isHidden = isUserSearch ? true : false
        cell?.spoolLbl.text = isUserSearch ? user.name : user.userName
        cell?.deleteSpoolBlock = {
            self.httpWrapper.performAPIRequest("user_time_logs/stop_tracking?user_id=\(user.id ?? 0)", methodType: "PUT", parameters: nil) { (responseData) in
                DispatchQueue.main.async {
                    print(responseData)
                    self.getItemAddedUsers()
                }
            } failBlock: { (error) in
                DispatchQueue.main.async {
                    self.showFailureAlert(with: (error?.localizedDescription)!)
                }
            }
        }
        return cell!
    }
    // check additionl users once scanned
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUserSearch {
//            add activity_tracker_ids - array of tracker ids
            let trackerIds = UserDefaults.standard.array(forKey: "activity_tracker_ids")
            let data = ["user_id":self.allAdditionalUsers[indexPath.row].id,"primary_user_id":currentUser.id!]
            //            let par = ["0":data]
            //            let trakerParams = ["user_time_logs_attributes":par] as [String : Any]
            let params = ["activity_tracker":["user_time_logs_attributes":["0":data]] as [String : Any],"activity_tracker_ids":trackerIds as Any] as [String:AnyObject]
            httpWrapper.performAPIRequest("activity_trackers/bulk_update", methodType: "PUT", parameters: params) { (responseData) in
                DispatchQueue.main.async {
                    print(responseData)
                    self.getItemAddedUsers()
                }
            } failBlock: { (error) in
                DispatchQueue.main.async {
                    self.showFailureAlert(with: (error?.localizedDescription)!)
                }
            }
//            params - top_tracking as true - on save and submit
        } else {
            return
        }
    }
}
