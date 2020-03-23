//
//  HangerDashBoardVC.swift
//  BKI
//
//  Created by sreenivasula reddy on 20/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class HangerDashBoardVC: BaseViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Proprties
    var dataArr = [HangersBoardItem.init(name: "Cut Rods", type: .cutRods),
                   HangersBoardItem.init(name: "Cut Structs", type: .cutStrructs),
                   HangersBoardItem.init(name: "Assemble", type: .assemble)]
   
    //MARK:- View Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.registerReusableCell(DashBoardCell.self)
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == HangersBoardDetailsSegue
        {
            guard let vc = segue.destination as? HangerDashBoardDetailsVC else { return }
            vc.hangerViewState = dataArr[((sender as? IndexPath)?.row)!].type
        }
    }
}

//MARK:- UITableViewDataSource methods
extension HangerDashBoardVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DashBoardCell
        cell.titleLbl.text = dataArr[indexPath.row].name
        return cell
    }
}

//MARK:- UITableViewDelegate methods
extension HangerDashBoardVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: HangersBoardDetailsSegue, sender: indexPath)
    }
}
