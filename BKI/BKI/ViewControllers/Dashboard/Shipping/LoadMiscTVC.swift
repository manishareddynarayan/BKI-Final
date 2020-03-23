//
//  LoadMiscTVC.swift
//  BKI
//
//  Created by srachha on 11/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class LoadMiscTVC: BaseTableViewController
{
    //MARK:- IBOutlets
    @IBOutlet var saveBtn: UIBarButtonItem!
    @IBOutlet weak var searchTF: AUTextField!
    //MARK:- Properties
    var load = Load()
    var material = Material()
    var materialsArr = [Material]()
    var text:String!
    var isSearchMisc = true
    //MARK:- View Life Cyccle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if load.materials.isEmpty
        {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "materialCell")
            searchTF.text = text
        }
        else
        {
            isSearchMisc = false
        }
        self.searchTF.textAlignment = .left
        self.searchTF.textColor = UIColor.white
        self.tableView.registerReusableCell(MiscCell.self)
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.hideNavigationController()
        let title = load.number != nil ? "Load Number " + self.load.number! : "New load"
        self.navigationItem.title = title
        searchTF.delegate = self
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    // MARK:- IBActions
    @IBAction func addnewMaterialAction(_ sender: Any)
    {
        let newMaterial = Material.init()
        self.load.materials.append(newMaterial)
        self.tableView.reloadData()
    }
    
    @IBAction func removeSearch(_ sender: Any)
    {
        isSearchMisc = false
        searchTF.text = ""
        self.tableView.register(UINib(nibName: "MiscCell", bundle: nil), forCellReuseIdentifier: "miscCell")
        tableView.reloadData()
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
//        let searchMiscVC = segue.destination as? SearchMiscVC
//        searchMiscVC?.load = self.load
//    }
}

// MARK: - Table view data source
extension LoadMiscTVC
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if isSearchMisc
        {
            if !((searchTF.text?.isEmpty)!) && self.materialsArr.isEmpty
            {
                return 1
            }
            return !(self.materialsArr.isEmpty) ? self.materialsArr.count : 0
        }
        return load.materials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isSearchMisc
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "materialCell")
            
            if indexPath.row == 0 && !((searchTF.text?.isEmpty)!) && self.materialsArr.isEmpty
            {
                cell?.textLabel?.text = "+ Add '\((searchTF?.text!)!)'"
                cell?.textLabel?.textColor = UIColor.brickRed
            }
            else
            {
                let material = self.materialsArr[indexPath.row]
                cell?.textLabel?.text = material.desc
                cell?.textLabel?.textColor = UIColor.black
            }
            return cell!
        }
        else
        {
            
            let cell:MiscCell = tableView.dequeueReusableCell(indexPath: indexPath) as MiscCell
            cell.indexPath = indexPath
            let material = load.materials[indexPath.row]
            cell.configureCell(material: material)
            cell.qtyTF.formDelegate = self
            //        cell?.decTF.formDelegate = self
            cell.weightTF.formDelegate = self
            //        cell?.descLbl.text = Weld.description()
            //        cell?.descEnterBlock = {
            //            let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "searchMiscVC", storyBoard: "Main") as? SearchMiscVC
            //            vc?.material = material
            //            self.present(vc!, animated: true, completiosn: {
            //
            //            })
            //        }
            cell.quantityCompletedBlock = { (text)  in
                if !(text.isEmpty) && (text.count) < 18 {
                    material.quantity = Int(text)!
                }
            }
            cell.weightCompletedBlock = { (text)  in
                if !(text.isEmpty) {
                    material.weight = Double(text)!
                }
            }
            
            cell.deleteMiscellaniousBlock = {
                
                guard material.id != nil else {
                    self.load.materials.remove(at: cell.indexPath.row)
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
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        searchTF.resignFirstResponder()
        if isSearchMisc
        {
            tableView.deselectRow(at: indexPath, animated: false)
            if indexPath.row == 0 && !((searchTF.text?.isEmpty)!) && self.materialsArr.isEmpty
            {
                self.material.desc = searchTF.text!
                createMaterial(materialDesc: searchTF.text!, indexPath: indexPath)
            }
            else
            {
                let material = self.materialsArr[indexPath.row]
                self.material.miscellaneousMaterialId = material.miscellaneousMaterialId
                self.material.desc = material.desc
                self.load.materials.append(material)
                isSearchMisc = false
                self.tableView.reloadData()
            }
            searchTF.text = ""
        }
    }
}
//MARK:- TextInput Delegate
extension LoadMiscTVC:TextInputDelegate
{
    func textFieldDidPressedNextButton(_ textField: AUSessionField)
    {
        self.moveToNextOrPrevCell(textField, next: true)
    }
    
    func textFieldDidPressedPreviousButton(_ textField: AUSessionField)
    {
        self.moveToNextOrPrevCell(textField, next: false)
    }
    
    func textFieldDidPressedDoneButton(_ textField: AUSessionField)
    {
        textField.resignFirstResponder()
    }
    
    func moveToNextOrPrevCell(_ textField:AUSessionField, next:Bool)
    {
        let currentTag = textField.tag
        let nextRow = next ? currentTag : currentTag-1
        let indexPath = IndexPath.init(row: nextRow, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as? MiscCell
        textField.resignFirstResponder()
        if next
        {
            //            let material = self.load.materials[indexPath.row]
            //            material.quantity = Int(textField.text!)!
            cell?.weightTF.becomeFirstResponder()
        }
        else
        {
            cell?.qtyTF.becomeFirstResponder()
        }
    }
}

//MARK:- UITextFieldDelegate Delegate
extension LoadMiscTVC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn
        range: NSRange, replacementString string: String) -> Bool
    {
        if textField == searchTF
        {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "materialCell")
            //            searchTF.text = text
            isSearchMisc = true
            var searchStr = textField.text! + string
            if !(searchStr.isEmpty)
            {
                searchStr = string.isEmpty ? String(searchStr.dropLast()) : searchStr
                self.searchForMaterial(text: searchStr)
            }
            return true
        }
        isSearchMisc = false
        //        let storyboard : UIStoryboard = UIStoryboard(name: "searchNavigationController", bundle: nil)
        //
        //        let vc = storyboard.instantiateViewController(withIdentifier: "searchMiscVC") as? SearchMiscVC
        //        let navigationController = UINavigationController(rootViewController: vc!)
        //
        //        self.present(navigationController, animated: true, completion: nil)
        
        //        self.performSegue(withIdentifier: "showSearchMiscSegue", sender: self)
        
        //        let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "searchMiscVC", storyBoard: "Main") as? SearchMiscVC
        //        vc?.load = self.load
        ////        vc?.material = matmerial
        ////        vc?.text =
        //        self.present(vc!, animated: false, completion: {
        //
        //        })
        return true
    }
}

extension LoadMiscTVC
{
    func createMaterial(materialDesc:String,indexPath:IndexPath)
    {
        var material:[String:AnyObject] = [String:AnyObject]()
        material["material"] = materialDesc as AnyObject
        HTTPWrapper.sharedInstance.performAPIRequest("miscellaneous_materials",
                                      methodType: "POST", parameters: material, successBlock: { (responseData) in
                                        DispatchQueue.main.async {
                                            print(responseData)
                                            self.materialsArr.removeAll()
                                            let material = Material.init(info: responseData)
                                            self.materialsArr.append(material)
                                            let newMaterial = self.materialsArr[indexPath.row]
                                            self.material.miscellaneousMaterialId = newMaterial.miscellaneousMaterialId
                                            self.material.desc = newMaterial.desc
                                            self.isSearchMisc = false
                                            self.load.materials.append(newMaterial)
                                            self.tableView.reloadData()
                                        }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }

    
    func searchForMaterial(text:String)
    {
        HTTPWrapper.sharedInstance.performAPIRequest("miscellaneous_materials/search?q=\(text)",
            methodType: "GET", parameters: nil, successBlock: { (responseData) in
                DispatchQueue.main.async {
                    self.materialsArr.removeAll()
                    let materials = responseData["results"] as? [[String:AnyObject]]
                    for mat in materials!
                    {
                        let material = Material.init(info: mat)
                        self.materialsArr.append(material)
                    }
                    self.tableView.reloadData()
                }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
}
