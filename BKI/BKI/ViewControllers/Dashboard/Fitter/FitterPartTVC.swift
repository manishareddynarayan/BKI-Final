//
//  FitterHeatTVC.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class FitterPartTVC: BaseTableViewController, TextInputDelegate {

    @IBOutlet var saveBtn: UIBarButtonItem!
    
    var role:Int!
    var viewState :DashBoardState = DashBoardState.none
    var spool:Spool?
    var components = [String:([String:([String:AnyObject])])]()
    let httpWrapper = HTTPWrapper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PartCell", bundle: nil), forCellReuseIdentifier: "partCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
        self.navigationItem.rightBarButtonItem = saveBtn
        saveBtn.isEnabled = !((self.spool?.components.isEmpty)!)  && self.spool?.loadedAt == nil
        self.tableView.reloadData()
        if self.spool?.loadedAt != nil{
            self.alertVC.presentAlertWithTitleAndMessage(title: "Warning", message: "You cannot modify heat numbers as the spool is added to a load", controller: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func saveAction(_ sender: Any) {
        var showAlert = false
        for component in (self.spool?.components)! {
            if component.heatNumber.isEmpty {
                showAlert = true
            }
        }
//        var components = [[String:AnyObject]]()
        for row in 0 ..< (self.spool?.components.count)! {
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? PartCell
            let textField = cell?.getTextField()
            textField?.resignFirstResponder()
        }
        
//        for component in (self.spool?.components)! {
//            let dict = ["id":component.id!, "heat_number": component.heatNumber] as [String : Any]
//            components.append(dict as [String : AnyObject])
//            if component.heatNumber.isEmpty {
//                showAlert = true
//            }
//        }
        
//        for component in (self.spool?.components)! {
//            self.components[String(component.id!)] = [String:([String:AnyObject])]()
//            self.components[String(component.id!)]!["heat_number_attributes"] = [String:AnyObject]()
//            self.components[String(component.id!)]!["heat_number_attributes"]!["number"] = component.heatNumber as AnyObject
//            self.components[String(component.id!)]!["heat_number_attributes"]!["done_by_id"] = User.shared.id as AnyObject
//        }
//        let spoolParams = ["component":self.components]
        
        if self.components.count > 0{
            MBProgressHUD.showHud(view: self.view)
                    httpWrapper.performAPIRequest("components/heat_numbers_update", methodType: "PUT", parameters: ["component":self.components as AnyObject], successBlock: { (responseData) in
                        DispatchQueue.main.async {
                            print(responseData)
                            MBProgressHUD.hideHud(view: self.view)
                            self.alertVC.presentAlertWithTitleAndMessage(title: "Success", message: "Heat numbers are updated.", controller: self)
                            if showAlert{
                                self.alertVC.presentAlertWithTitleAndMessage(title: "Warning", message: "Please enter heat numbers to move the spool to next state", controller: self)
                            }
                            self.navigationController?.popViewController(animated: true)
                            self.tableView.reloadData()
                        }
                    }) { (error) in
                        self.showFailureAlert(with:(error?.localizedDescription)! )
                    }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.spool?.components.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as? PartCell
        cell?.indexPath = indexPath
        let component = self.spool?.components[indexPath.row]
        let isLoaded = self.spool?.loadedAt != nil ? true : false
        if indexPath.row == 0 {
            cell?.configureCell(component: component!, isNext:true, isPrev: false, isLoaded: isLoaded)
        }
        else if indexPath.row == (self.spool?.components.count)! - 1 {
            cell?.configureCell(component: component!, isNext:false, isPrev: true, isLoaded: isLoaded)
        }
        else {
            cell?.configureCell(component: component!, isNext:true, isPrev: true, isLoaded: isLoaded)
        }
        cell?.heatTF.formDelegate = self
        cell?.updatedHeatNumber = { component in
            self.components[String(component.id!)] = [String:([String:AnyObject])]()
            self.components[String(component.id!)]!["heat_number_attributes"] = [String:AnyObject]()
            self.components[String(component.id!)]!["heat_number_attributes"]!["number"] = component.heatNumber as AnyObject
            self.components[String(component.id!)]!["heat_number_attributes"]!["done_by_id"] = User.shared.id as AnyObject
        }
        return cell!
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func moveToNextOrPrevCell(_ textField:AUSessionField, next:Bool) {
        let currentTag = textField.tag
        let nextRow = next ? currentTag+1 : currentTag-1
        let indexPath = IndexPath.init(row: nextRow, section: 0)
        let nextCell = self.tableView.cellForRow(at: indexPath) as? PartCell
        textField.resignFirstResponder()
        nextCell?.heatTF.becomeFirstResponder()
    }
    
    //MARK: TextInput Delegate
    func textFieldDidPressedNextButton(_ textField: AUSessionField) {
        self.moveToNextOrPrevCell(textField, next: true)
    }
    
    func textFieldDidPressedPreviousButton(_ textField: AUSessionField) {
        self.moveToNextOrPrevCell(textField, next: false)
    }
    
    func textFieldDidPressedDoneButton(_ textField: AUSessionField) {
        textField.resignFirstResponder()
    }
}
