//
//  PackageViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 17/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class PackageViewController: BaseViewController {

    @IBOutlet var packageDashboardTableView: UITableView!
    var menuItems: [[String:String]]!
//    var hanger:Hanger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuItems = User.shared.getHangersMenu()
        packageDashboardTableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
        self.packageDashboardTableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Package : \(hanger?.packageName ?? "")"
        self.packageDashboardTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        packageDashboardTableView.reloadData()
        // Do any aditional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        packageDashboardTableView.reloadData()
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
extension PackageViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return menuItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as? DashBoardCell
        let menu = self.menuItems[indexPath.row]
        cell?.countLabel.isHidden = true
        cell?.titleLbl.text = menu["Name"]
        cell?.enable(enable: true)
        if let additionalUsers = UserDefaults.standard.array(forKey: "additional_users") {
            if ((indexPath.row == self.menuItems.count - 2) && (additionalUsers.count != 0) && cell?.isUserInteractionEnabled == true)
            {
                cell?.countLabel.isHidden = false
                cell?.countLabel.text = String(additionalUsers.count)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "AssembleViewController", storyBoard: "Hangers") as? AssembleViewController else {
                return
            }
            vc.hanger = self.hanger
            self.navigationController?.pushViewController(vc, animated: true)
        }  else if indexPath.row == 2 {
            guard let vc = self.getViewControllerWithIdentifier(identifier: "AdditionalUsersViewController") as? AdditionalUsersViewController  else {
                return
            }
            vc.trackerId = self.trackerId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let menu = self.menuItems[indexPath.row]
                guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "CuttingStatsViewController", storyBoard: "Hangers") as? CuttingStatsViewController else {
                    return
                }
                vc.cuttingType = menu["Name"]
                vc.hanger = self.hanger
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
}
