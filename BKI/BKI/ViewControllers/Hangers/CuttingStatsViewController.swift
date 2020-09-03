//
//  CuttingStatsViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class CuttingStatsViewController: BaseViewController {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    var cuttingType:String?
//    var hanger:Hanger?
    var cuttingStats = [CuttingStat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RodPackageTableViewCell", bundle: nil), forCellReuseIdentifier: "RodPackageTableViewCell")
        tableView.register(UINib(nibName: "StrutPackageTableViewCell", bundle: nil), forCellReuseIdentifier: "StrutPackageTableViewCell")
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.navigationItem.title = "Package: \(hanger?.packageName ?? "")"
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        titleLabel.text = hanger?.packageName
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.getCuttingStatData { (completed) in
            print("completed")
        }
        // Do any additional setup after loading the view.
    }
    
    func getCuttingStatData(completeHandler:@escaping (Bool) -> ()) {
        MBProgressHUD.showHud(view: self.view)
        
        let type = cuttingType == "Cut Rods" ? "rod_cuttings" : "unistrut_cuttings"
        httpWrapper.performAPIRequest("packages/\(hanger?.packageId ?? 0)/hangers/\(hanger?.id ?? 0)/cutting_stats?cutting_type=\(type)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.cuttingStats.removeAll()
                let cuttingStats =  responseData["cutting_stats"] as! [[String:AnyObject]]
                for cuttingStatInfo in cuttingStats {
                    let stat = CuttingStat.init(info: cuttingStatInfo)
                    self.cuttingStats.append(stat)
                }
                self.tableView.reloadData()
                completeHandler(true)
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
extension CuttingStatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuttingStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cuttingType == "Cut Rods" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StrutPackageTableViewCell", for: indexPath) as?  StrutPackageTableViewCell
            let cuttingStat = cuttingStats[indexPath.row]
            cell?.sizeLabel.text = cuttingStat.size
            cell?.descriptionLabel.text = cuttingStat.desc
            cell?.viewDetails = {
                guard  let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "SolutionsViewController", storyBoard: "Hangers") as? SolutionsViewController else {
                    return
                }
                vc.selectedStatId = cuttingStat.id
                vc.cuttingStat = cuttingStat
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            }
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RodPackageTableViewCell", for: indexPath) as? RodPackageTableViewCell
        let cuttingStat = cuttingStats[indexPath.row]
        cell?.DescriptionLabel.text = cuttingStat.desc
        cell?.viewDetails = {
            guard  let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "SolutionsViewController", storyBoard: "Hangers") as? SolutionsViewController else {
                return
            }
            vc.selectedStatId = cuttingStat.id
            vc.cuttingStat = cuttingStat
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        return cell!
    }
}

extension CuttingStatsViewController: SolutionDelegate,SolutionDetailsDelegate{
    func backPressed(selectedStatId: Int, didChooseSolution: Bool) {
        guard  let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "SolutionsViewController", storyBoard: "Hangers") as? SolutionsViewController else {
            return
        }
        self.getCuttingStatData { (completed) in
            if completed {
                vc.selectedStatId = selectedStatId
                let cuttingStat = self.cuttingStats.filter({$0.id == selectedStatId}).first
                vc.cuttingStat = cuttingStat
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func solutionDidSelect(didChoose: Bool, solutionId: Int, isSolutionSelected: Bool, selectedStatId: Int) {
        guard let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: "SolutionDetailsViewController", storyBoard: "Hangers") as? SolutionDetailsViewController else {
            return
        }
        vc.delegate = self
        vc.solutionId = solutionId
        vc.didChooseSolution = didChoose
        vc.isSolutionSelected = isSolutionSelected
        vc.selectedStatId = selectedStatId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
