//
//  OpenLoadVC.swift
//  BKI
//
//  Created by srachha on 01/10/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class OpenLoadVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var openLoadsArr = [Load]()
    var tatalPages = 1
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "OpenLoadCell", bundle: nil), forCellReuseIdentifier: "openLoadCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.removeObject(forKey: "trackerIdsArray")
        if self.openLoadsArr.isEmpty {
            self.getOpenLoads()
        }
    }
    // store all tracker ids we get in getAPI and use to send them in additional user, take any one id from it for next API call
    func getOpenLoads() {
        MBProgressHUD.showHud(view: self.view)

        self.httpWrapper.performAPIRequest("loads?page=\(self.currentPage)", methodType: "GET",
        parameters: nil, successBlock: { (responseData) in
            let loads = responseData["loads"] as? [[String:AnyObject]]
            self.tatalPages = responseData["meta"]!["total_pages"] as! Int
            if self.currentPage == 1 {
                self.openLoadsArr.removeAll()
            }
            for load in loads! {
                let openLoad = Load.init(info: load)
                self.openLoadsArr.append(openLoad)
            }
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openLoadsArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "openLoadCell", for: indexPath) as? OpenLoadCell
        let load = self.openLoadsArr[indexPath.row]
        cell?.loadLbl.text = load.number!
        cell!.loadEditBlock = {
            guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier:
                "NewLoadVC", storyBoard: "Main") as? NewLoadVC else {
                return
            }
            vc.load = load
            vc.isEdit = true
            vc.role = self.role
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.openLoadsArr.count-1 {
            if self.tatalPages > self.currentPage {
                self.currentPage = self.currentPage + 1
                 self.getOpenLoads()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
