//
//  AssembleViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 24/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class AssembleViewController: UIViewController {

    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var hanger:Hanger?
    var selectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AssembleTableViewCell", bundle: nil), forCellReuseIdentifier: "AssembleTableViewCell")
//        self.bgImageview.isHidden = true
//        self.view.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()

        // Do any additional setup after loading the view.
    }
    

    func getAllHangerItems() {
        
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AssembleTableViewCell", for: indexPath) as? AssembleTableViewCell
        cell?.animate()
        if selectedIndex == indexPath {
            cell?.bgView.backgroundColor = UIColor.cellBackGroundDark
        } else {
            cell?.bgView.backgroundColor = UIColor.cellBackGroundLight
        }
        cell?.bgView.cornerRadius = 13
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath {
            return 205
        }
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
