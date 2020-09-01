//
//  AssembleViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 24/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class AssembleViewController: BaseViewController {
    
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
//    var hanger:Hanger?
    var allHangerItemsNextPage = 1
    var hangerAssemble:HangerAssemble?
    var hangerAssembleItems = [HangerAssembleItem]()
    var isHangerItemNextPageAvailable : Bool = true
    var previousIndex:IndexPath?
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AssembleTableViewCell", bundle: nil), forCellReuseIdentifier: "AssembleTableViewCell")
        self.navigationItem.title = "Assemble"
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        getAllHangerItems()
        // Do any additional setup after loading the view.
    }
    
    func getAllHangerItems() {
        if !isHangerItemNextPageAvailable {
            return
        }
        if allHangerItemsNextPage == 1 {
            MBProgressHUD.showHud(view: self.view)
        }
        self.httpWrapper.performAPIRequest("packages/\(hanger?.packageId ?? 0)/hangers/\(hanger!.id ?? 0)/hanger_items?ios=true&page=\(allHangerItemsNextPage)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                let hangerAssembleInfo = HangerAssemble.init(info: responseData)
                self.hangerAssemble = hangerAssembleInfo
                self.hangerAssembleItems.append(contentsOf: hangerAssembleInfo.hangerAssembleItems)
                (self.allHangerItemsNextPage, self.isHangerItemNextPageAvailable) = validateMetaData(meta: responseData["meta"] as! [String:Int])
                self.packageNameLabel.text = self.hanger?.packageName
                self.tableView.reloadData()
                self.getAllHangerItems()
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension AssembleViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hangerAssembleItems.isEmpty ? 0 : hangerAssembleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssembleTableViewCell", for: indexPath) as? AssembleTableViewCell
        let hangerItem = hangerAssembleItems[indexPath.row]
        cell?.designCellWith(model: hangerItem)
//        cell?.animate()
        cell?.selectionButton.isHidden = !(hangerAssemble?.cuttingCompleted)!
        let image = hangerItem.completed ?? false ? "Check" : "unCheck"
        cell?.selectionButton.setImage(UIImage.init(named: image), for: .normal)
        if selectedIndex == indexPath {
            cell?.bgView.backgroundColor = UIColor.cellBackGroundDark
            UIView.animate(withDuration: 0.4, animations: {
                cell?.dropDownImgView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
        } else {
            cell?.bgView.backgroundColor = UIColor.cellBackGroundLight
            UIView.animate(withDuration: 0.4, animations: {
                cell?.dropDownImgView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
        }
        cell?.lowerView.isHidden = selectedIndex == indexPath ? false : true
        cell?.bgView.cornerRadius = 13
        cell?.optionSelected = {
            if hangerItem.completed! {
                return
            }
            let yesClosure: () -> Void = {
                MBProgressHUD.showHud(view: self.view)
                let itemParams = ["completed":true]
                self.httpWrapper.performAPIRequest("packages/\(self.hanger?.packageId ?? 0)/hangers/\(self.hanger!.id ?? 0)/hanger_items/\(hangerItem.id ?? 0)?ios=true", methodType: "PUT", parameters: ["hanger_item":itemParams as AnyObject], successBlock: { (responseData) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hideHud(view: self.view)
                        let updatedItem = HangerAssembleItem.init(info: responseData)
                        hangerItem.completed = true
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }) { (error) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hideHud(view: self.view)
                        self.showFailureAlert(with: (error?.localizedDescription)!)
                    }
                }
            }
            let noClosure: () -> Void = {
                
            }
            let buttonTitles = ["Yes","No"]
            self.alertVC.presentAlertWithActions(actions:  [yesClosure,noClosure], buttonTitles: buttonTitles, controller: self, message: "Did you assemble \(hangerItem.quantity ?? "") \(hangerItem.hangerNumber ?? "") Hangers?")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath {
            return 254
        }
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath {
            return
        }
        previousIndex = selectedIndex
        selectedIndex = indexPath
        tableView.beginUpdates()
        if previousIndex?.isEmpty ?? true {
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            tableView.reloadRows(at: [indexPath,previousIndex!], with: .none)
        }
        tableView.endUpdates()
    }
}
