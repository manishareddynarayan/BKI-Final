//
//  MainDashBoardVC.swift
//  BKI
//
//  Created by srachha on 19/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

class MainDashBoardVC: BaseViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Proprties
    var roleArr = [MainDashBoardItem.init(name: "Fit-Up", type: .fitup),
                   MainDashBoardItem.init(name: "Weld", type: .weld),
                   MainDashBoardItem.init(name: "Shipping", type: .shipping),
                   MainDashBoardItem.init(name: "Hangers", type: .hangers)]
   
    //MARK:- View Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.registerReusableCell(DashBoardCell.self)
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        
        if BKIModel.userRole() == "qa"
        {
            self.roleArr.removeAll()
            self.roleArr.append(MainDashBoardItem.init(name:"QA", type: .qa))
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction methods
    @IBAction func logoutAction(_ sender: Any)
    {
        self.logoutUser()
    }
    
    // MARK:- Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == DASHBOARDSEGUE
        {
            guard let vc = segue.destination as? DashBoardVC else { return }
            vc.viewState = roleArr[((sender as? IndexPath)?.row)!].type
        }
    }
}

//MARK:- UITableViewDataSource methods
extension MainDashBoardVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.roleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:DashBoardCell = tableView.dequeueReusableCell(indexPath: indexPath) as DashBoardCell
        cell.titleLbl.text = roleArr[indexPath.row].name
        return cell
    }
}

//MARK:- UITableViewDelegate methods
extension MainDashBoardVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: DASHBOARDSEGUE, sender: indexPath)
    }
}
