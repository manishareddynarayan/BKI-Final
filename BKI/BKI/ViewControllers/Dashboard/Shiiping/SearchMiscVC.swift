//
//  LoadMiscVC.swift
//  BKI
//
//  Created by srachha on 21/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class SearchMiscVC: BaseViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var material = Material()
    var materialsArr = [Material]()
    @IBOutlet weak var searchTF: AUTextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.textAlignment = .left
        self.searchTF.textColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "materialCell")
        
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    func searchForMaterial(text:String) {
        httpWrapper.performAPIRequest("miscellaneous_materials/search?q=\(text)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.materialsArr.removeAll()
                let materials = responseData["results"] as? [[String:AnyObject]]
                for mat in materials! {
                    let material = Material.init(info: mat)
                    self.materialsArr.append(material)
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    /*
     // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchTF.text?.count)! > 0 && self.materialsArr.count == 0 {
            return 1
        }
        return self.materialsArr.count > 0 ? self.materialsArr.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "materialCell")
        
        if indexPath.row == 0 && (searchTF.text?.count)! > 0 && self.materialsArr.count == 0 {
            cell?.textLabel?.text = "+ Add '\((searchTF?.text!)!)'"
            cell?.textLabel?.textColor = UIColor.brickRed
        }
        else {
            let material = self.materialsArr[indexPath.row]
            cell?.textLabel?.text = material.desc
            cell?.textLabel?.textColor = UIColor.black
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 && (searchTF.text?.count)! > 0 && self.materialsArr.count == 0 {
            self.material.desc = searchTF.text!
        }
        else {
            let material = self.materialsArr[indexPath.row]
            self.material.miscellaneousMaterialId = material.id
            self.material.desc = material.desc
        }
        self.dismiss(animated: true, completion: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchStr = textField.text! + string
        if searchStr.count > 3 {
            self.searchForMaterial(text: searchStr)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
