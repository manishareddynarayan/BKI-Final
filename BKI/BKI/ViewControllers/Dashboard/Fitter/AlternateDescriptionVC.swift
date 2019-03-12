//
//  AlternateDescriptionVC.swift
//  BKI
//
//  Created by Anchal Kumar Gupta on 06/03/19.
//  Copyright © 2019 srachha. All rights reserved.
//

import UIKit

class AlternateDescriptionVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var cell:AlternateDescriptionCell!
    var data:[[String:AnyObject]] = [[:]]
    var spoolID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AlternateDescriptionCell", bundle: nil), forCellReuseIdentifier: "alternateDescriptionCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        noDataLbl.isHidden = true
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
     }
    
    @IBAction func backBtn(_ sender: Any) {
        self.backButtonAction(sender: sender as AnyObject)
    }
    
    func getData(){
        MBProgressHUD.showHud(view: self.view)
        httpWrapper.performAPIRequest("spools/\(String(describing: self.spoolID!))/spool_grouped_components", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                self.setData(responseData: responseData)
                MBProgressHUD.hideHud(view: self.view)
                self.tableView.reloadData()
                if self.data.count <= 1{
                    self.noDataLbl.isHidden = false
                }else{
                    self.noDataLbl.isHidden = true
                }
            }
        }) { (error) in
            MBProgressHUD.hideHud(view: self.view)

            self.showFailureAlert(with: (error?.localizedDescription)!)
        }
    }
    
    func setData(responseData:[String:AnyObject]){
        for (key,value) in responseData{
            if key != "Pipe"{
                for i in 0...(responseData[key]!.count! - 1){
                    let valueDict = ((value as? NSArray)![i] as? [String:AnyObject])!
                    data.append(["key":key as AnyObject,"alternate_description":valueDict["alternate_description"]!, "item_notes":valueDict["item_notes"]!, "size":valueDict["size"]!])
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "alternateDescriptionCell") as? AlternateDescriptionCell
        var heading:String = ""
        var size:String = ""
        var notes:String = ""
        var description:String = ""
        if data.count>1{
            if let headingCheck = data[indexPath.row + 1]["key"] as? String{
                heading = headingCheck.uppercased()
            }
            if let sizeCheck = data[indexPath.row + 1]["size"] as? String{
                size = sizeCheck
            }
            if let notesCheck = data[indexPath.row + 1]["item_notes"] as? String{
                notes = notesCheck
            }
            if let descriptionCheck = data[indexPath.row + 1]["alternate_description"] as? String{
                description = descriptionCheck
            }
            cell.setCell(heading: heading, size: size, notes: notes, description: description)
        }
        return cell
    }
}
