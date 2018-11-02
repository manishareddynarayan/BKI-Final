//
//  LoadMiscTVC.swift
//  BKI
//
//  Created by srachha on 11/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoadMiscTVC: BaseTableViewController, TextInputDelegate {

    var load = Load()
    @IBOutlet var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "MiscCell", bundle: nil), forCellReuseIdentifier: "miscCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.hideNavigationController()
        self.navigationItem.title = "Load Number " + self.load.number!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return load.materials.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "miscCell", for: indexPath) as? MiscCell
        
        cell?.indexPath = indexPath
        let material = load.materials[indexPath.row]
        cell?.configureCell(material: material)
        cell?.qtyTF.formDelegate = self
        cell?.decTF.formDelegate = self
        cell?.descEnterBlock = {
            let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "searchMiscVC", storyBoard: "Main") as? SearchMiscVC
            vc?.material = material
            self.present(vc!, animated: true, completion: {
                
            })
        }
        cell?.quantityCompletedBlock = {
            if (cell?.qtyTF.text?.count)! > 0 {
                material.quantity = Int((cell?.qtyTF.text!)!)!
            }
        }
        
        cell?.deleteMiscellaniousBlock = {
            
           guard material.id != nil else {
                self.load.materials.remove(at: cell!.indexPath.row)
                self.tableView.reloadData()
                return
            }
            var load_param = [String:AnyObject]()
            load_param["id"] = self.load.id! as AnyObject
            let dict = ["id":material.id!,"quantity":material.quantity,"_destroy":true] as [String : Any]
            var misc_material_attributes = [[String:AnyObject]]()
            misc_material_attributes.append(dict as [String : AnyObject])
            load_param["loads_miscellaneous_materials_attributes"] = misc_material_attributes as AnyObject
            var params = [String:AnyObject]()
            params["load"] = load_param as AnyObject
            MBProgressHUD.showHud(view: self.view)
            
            HTTPWrapper.sharedInstance.performAPIRequest("loads/\(self.load.id!)", methodType: "PUT",
                                               parameters: params as [String : AnyObject],
                                               successBlock: { (responseData) in
                            DispatchQueue.main.async {
                                MBProgressHUD.hideHud(view: self.view)
                                                    
                                self.load.saveLoad(loadInfo: responseData)
                                self.tableView.reloadData()
                                let okClosure: () -> Void = {
                                        self.navigationController?.popViewController(animated: true)
                                }
                                self.alertVC.presentAlertWithTitleAndActions(actions: [okClosure],
                                        buttonTitles: ["OK"], controller: self,
                                        message:"Material deleted successfully." , title: "Success")
                                }
            }) { (error) in
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }

        return cell!
    }
 
    @IBAction func addnewMaterialAction(_ sender: Any) {
        let newMaterial = Material.init()
        self.load.materials.append(newMaterial)
        self.tableView.reloadData()
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
        let nextRow = next ? currentTag : currentTag-1
        let indexPath = IndexPath.init(row: nextRow, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as? MiscCell
        textField.resignFirstResponder()
        if next {
            let material = self.load.materials[indexPath.row]
            material.quantity = Int(textField.text!)!
            cell?.decTF.becomeFirstResponder()
        }
        else {
            cell?.qtyTF.becomeFirstResponder()
        }
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
