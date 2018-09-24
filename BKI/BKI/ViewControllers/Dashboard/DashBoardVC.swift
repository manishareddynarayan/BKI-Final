//
//  DashBoardVC.swift
//  BKI
//
//  Created by srachha on 19/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class DashBoardVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var menuItems: [[String:String]]!
    var scanCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuItems = User.shared.getUserMenuItems()

        tableView.register(UINib(nibName: "DashBoardCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK:- Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:TableView DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as? DashBoardCell
        let menu = self.menuItems[indexPath.row]
        //cell?.container.backgroundColor = (self.scanCode == nil) ? :
        cell?.container.alpha = (self.scanCode == nil) ? 0.5 : 1.0
        cell?.titleLbl.text = menu["Name"]
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard self.scanCode != nil else {
            return
        }
        let menu = self.menuItems[indexPath.row]
        self.pushViewControllerWithIdentifierAndStoryBoard(identifier: menu["Child"]!, storyBoard: "Main")
    }
}
