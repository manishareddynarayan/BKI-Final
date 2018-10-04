//
//  FitterHeatTVC.swift
//  BKI
//
//  Created by srachha on 26/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class FitterPartTVC: UITableViewController, TextInputDelegate {

    var role:Int!
    var heatArr = [Part]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "PartCell", bundle: nil), forCellReuseIdentifier: "partCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        for idx in 1...100 {
            let part = Part.init(info: ["name":"\(idx)" as AnyObject, "number":"" as AnyObject])
            self.heatArr.append(part)
        }
        self.navigationItem.title = BKIModel.spoolNumebr()

        self.tableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heatArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as? PartCell
        cell?.indexPath = indexPath
        let part = self.heatArr[indexPath.row]
        print("row \(indexPath.row)", "number \(part.heatNumber)")
        if indexPath.row == 0 {
            cell?.configureCell(part: part, isNext:true, isPrev: false)
        }
        else if indexPath.row == self.heatArr.count - 1 {
            cell?.configureCell(part: part, isNext:false, isPrev: true)
        }
        else {
            cell?.configureCell(part: part, isNext:true, isPrev: true)
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
