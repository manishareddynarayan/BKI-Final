//
//  SolutionsViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 18/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

@objc protocol SolutionDelegate
{
    @objc optional func viewDetailsSolution()
    @objc optional func didChooseSolution()
}

class SolutionsViewController: BaseViewController {
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    weak var delegate:SolutionDelegate!

    var cuttingStat:CuttingStat?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SolutionTableViewCell", bundle: nil), forCellReuseIdentifier: "SolutionTableViewCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.sizeLabel.text = cuttingStat?.size
        self.navigationController?.navigationBar.isHidden = true
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.appRed.withAlphaComponent(0.9)
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
        cell?.prepareSolutionCellWith(solution: solution)
        cell?.viewDetails = {
            self.dismiss(animated: false) {
                            self.delegate.viewDetailsSolution?()
            }
        }
        cell?.chooseSolution = {
            let solutionToDelete = self.cuttingStat!.solutions.filter({$0.id != solution.id }).first
            MBProgressHUD.showHud(view: self.view)
            self.httpWrapper.performAPIRequest("nest_solutions/\(solutionToDelete!.id ?? 0)", methodType: "DELETE", parameters: nil, successBlock: { (responseData) in
                                            DispatchQueue.main.async {
                                                MBProgressHUD.hideHud(view: self.view)
                                                self.dismiss(animated: false) {
self.delegate.didChooseSolution?()
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
