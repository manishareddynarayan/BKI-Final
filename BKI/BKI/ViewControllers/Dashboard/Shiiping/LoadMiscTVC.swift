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
        let title = load.number != nil ? "Load Number " + self.load.number! : "New load"
        self.navigationItem.title = title
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
        cell?.weightTF.formDelegate = self
        cell?.descEnterBlock = {
            let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "searchMiscVC", storyBoard: "Main") as? SearchMiscVC
            vc?.material = material
            self.present(vc!, animated: true, completion: {
                
            })
        }
        cell?.quantityCompletedBlock = { (text)  in
            if (text.count) > 0 {
                material.quantity = Int(text)!
            }                
        }
        cell?.weightCompletedBlock = { (text)  in
            if (text.count) > 0 {
                material.weight = Int(text)!
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
            let dict = ["id":material.id!,"quantity":material.quantity,"_destroy":true,"weight":material.weight] as [String : Any]
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
//                                        self.navigationController?.popViewController(animated: true)
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
