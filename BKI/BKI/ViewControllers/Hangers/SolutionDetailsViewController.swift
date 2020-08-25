//
//  SolutionDetailsViewController.swift
//  BKI
//
//  Created by Narayan Manisha on 19/08/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

protocol SolutionDetailsDelegate
{
    func backPressed(selectedStatId:Int,didChooseSolution:Bool)
}

class SolutionDetailsViewController: BaseViewController {
    
    @IBOutlet weak var materialNameLabel: UILabel!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    var delegate:SolutionDetailsDelegate!
    var solutionId:Int?
    var didChooseSolution:Bool?
    var isSolutionSelected:Bool?
    var packageBundle:PackageBundle?
    var selectedStatId:Int?
    var changedData =  [Int:Bool]()
    var testMethodsWelds : [String:([String:Bool])] = [String: [String:Bool]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PackageDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PackageDetailsTableViewCell")
        self.bgImageview.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView = self.view.emptyViewToHideUnNecessaryRows()
        self.getPackageBundleDetails()
        //        let completedBundles = packageBundle?.bundles.filter({$0.completed})

        // Do any additional setup after loading the view.
    }
    
    func getPackageBundleDetails() {
        MBProgressHUD.showHud(view: self.view)
        self.httpWrapper.performAPIRequest("bundle_infos?nest_id=\(solutionId ?? 0)", methodType: "GET", parameters: nil, successBlock: { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.packageBundle = PackageBundle.init(info: responseData)
                self.materialNameLabel.text = self.packageBundle?.materialName
                for bundle in self.packageBundle!.bundles {
                    self.changedData.updateValue(bundle.completed, forKey: bundle.id!)
                }
                self.packageNameLabel.text = self.packageBundle?.packageName
                self.sizeLabel.text = self.packageBundle?.size
                if self.packageBundle?.desc != nil {
                    self.descriptionLabel.text = self.packageBundle?.desc
                } else {
                    self.descriptionLabel.text = ""
                    self.descriptionTitle.text = ""
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.showFailureAlert(with: (error?.localizedDescription)!)
            }
        }
    }
    func submitBundle() {
//        var components = [String:AnyObject]()
        
        for component in changedData {
            self.testMethodsWelds["\(component.key)"] = ["completed":component.value]
//            let dict = ["\(component.key)":["completed":component.value]]
//            components.append(dict as [String : AnyObject])
        }
        let spoolParams = ["bundle_info":testMethodsWelds]
        MBProgressHUD.showHud(view: self.view)
        self.httpWrapper.performAPIRequest("bundle_infos/update_bundles", methodType: "PUT", parameters: spoolParams as [String : AnyObject], successBlock: { (responseData) in
            DispatchQueue.main.async {
                MBProgressHUD.hideHud(view: self.view)
                self.getPackageBundleDetails()
            }
        }) { (error) in
            MBProgressHUD.hideHud(view: self.view)
            self.showFailureAlert(with:(error?.localizedDescription)! )
        }
    }
    
    override func backButtonAction(sender: AnyObject?) {
        self.delegate.backPressed(selectedStatId: self.selectedStatId!, didChooseSolution: self.didChooseSolution!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeOnClick(_ sender: Any) {
        self.submitBundle()
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
extension SolutionDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageBundle != nil ? (packageBundle?.bundles.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailsTableViewCell", for: indexPath) as? PackageDetailsTableViewCell
        let bundleData = packageBundle?.bundles[indexPath.row]
        cell?.label1.text = "Nest Bundle: \(indexPath.row + 1)"
        cell?.designCellWith(bundleData: bundleData!, showCheckButton: (self.didChooseSolution! || self.isSolutionSelected!))
        cell?.optionSelected = {
            if self.changedData[bundleData!.id ?? 0]! {
                self.changedData[bundleData!.id ?? 0] = false
            } else {
                self.changedData[bundleData!.id ?? 0] = true
            }
            let image = self.changedData[(bundleData?.id)!]! ? "Check" : "unCheck"
            cell?.selectionButton.setImage(UIImage.init(named: image), for: .normal)
        }
        let image = changedData[(bundleData?.id)!]! ? "Check" : "unCheck"
        cell?.selectionButton.setImage(UIImage.init(named: image), for: .normal)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: tableView.frame.size.width, height: 100))
        let footerView = UIView(frame: rect)
        footerView.backgroundColor = UIColor.white.withAlphaComponent(0)
        return footerView
    }
}
