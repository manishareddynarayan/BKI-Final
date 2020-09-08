//
//  SolutionsViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

 protocol SolutionDelegate
{
    func solutionDidSelect(didChoose:Bool,solutionId:Int,isSolutionSelected:Bool,selectedStatId:Int)
}

class SolutionsViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet weak var sizeTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var delegate:SolutionDelegate!
    var cuttingStat:CuttingStat?
    var selectedStatId:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SolutionTableViewCell", bundle: nil), forCellReuseIdentifier: "SolutionTableViewCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.descriptionLabel.text = cuttingStat?.desc
        self.navigationController?.navigationBar.isHidden = true
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.appRed.withAlphaComponent(0.9)
        if cuttingStat?.size != nil {
            self.sizeLabel.text = cuttingStat?.size
            titleLabel.text = "Rod Cutting"
        } else {
            self.sizeLabel.text = ""
            self.sizeTitle.text = ""
            titleLabel.text = "Struct Cutting"
        }
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func crossOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SolutionsViewController :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cuttingStat!.solutions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SolutionTableViewCell", for: indexPath) as? SolutionTableViewCell
        let solution = self.cuttingStat!.solutions[indexPath.row]
        let showChooseOption = self.cuttingStat!.solutions.count > 1
        cell?.titleLabel.text = "Solution \(indexPath.row + 1)"
        cell?.prepareSolutionCellWith(solution: solution, showChooseOption: showChooseOption)
        cell?.viewDetails = {
            self.dismiss(animated: false) {
                self.delegate.solutionDidSelect(didChoose: false, solutionId: solution.id!, isSolutionSelected: self.cuttingStat!.solutions.count == 1, selectedStatId: self.selectedStatId!)
            }
        }
        cell?.chooseSolution = {
            let solutionToDelete = self.cuttingStat!.solutions.filter({$0.id != solution.id }).first
            MBProgressHUD.showHud(view: self.view)
            self.httpWrapper.performAPIRequest("nest_solutions/\(solutionToDelete!.id ?? 0)", methodType: "DELETE", parameters: nil, successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                self.dismiss(animated: false) {
                                                    self.delegate.solutionDidSelect(didChoose: true, solutionId: solution.id!, isSolutionSelected: self.cuttingStat!.solutions.count == 1, selectedStatId: self.selectedStatId!)
                                                }
                }
            }) { (error) in
                            DispatchQueue.main.async {
                    MBProgressHUD.hideHud(view: self.view)
                                self.showFailureAlert(with: (error?.localizedDescription)!)
                }
            }
        }
        return cell!
    }
}
