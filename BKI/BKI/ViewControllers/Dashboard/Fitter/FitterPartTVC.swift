//
//  FitterHeatTVC.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class FitterPartTVC: BaseTableViewController, TextInputDelegate {

    var role:Int!
    var spool:Spool?
    @IBOutlet var saveBtn: UIBarButtonItem!
    let httpWrapper = HTTPWrapper.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PartCell", bundle: nil), forCellReuseIdentifier: "partCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Spool Number " + BKIModel.spoolNumebr()!
        self.navigationItem.rightBarButtonItem = saveBtn
        saveBtn.isEnabled = (self.spool?.components.count)! > 0 ? true : false
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        var components = [[String:AnyObject]]()
        
        for component in (self.spool?.components)! {
            let dict = ["id":component.id!, "heat_number": component.heatNumber] as [String : Any]
            components.append(dict as [String : AnyObject])
        }
        let spoolParams = ["components_attributes":components]
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\((self.spool?.id)!)", methodType: "PUT", parameters: ["spool":spoolParams as AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                print(responseData)
                MBProgressHUD.hideHud(view: self.view)
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showFailureAlert(with:(error?.localizedDescription)! )
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
        if indexPath.row == 0 {
            cell?.configureCell(component: component!, isNext:true, isPrev: false)
        }
        else if indexPath.row == (self.spool?.components.count)! - 1 {
            cell?.configureCell(component: component!, isNext:false, isPrev: true)
        }
        else {
            cell?.configureCell(component: component!, isNext:true, isPrev: true)
        }
        cell?.heatTF.formDelegate = self

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
