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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "OpenLoadCell", bundle: nil), forCellReuseIdentifier: "openLoadCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getOpenLoads()
    }
    
    func getOpenLoads() {
        self.httpWrapper.performAPIRequest("loads", methodType: "GET",
        parameters: nil, successBlock: { (responseData) in
            let loads = responseData["loads"] as? [[String:AnyObject]]
            self.openLoadsArr.removeAll()
            for load in loads! {
                let openLoad = Load.init(info: load)
                self.openLoadsArr.append(openLoad)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
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

    //MARK: TableView DataSource methods
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
