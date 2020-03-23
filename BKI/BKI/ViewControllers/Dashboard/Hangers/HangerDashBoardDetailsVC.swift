//
//  HangerDashBoardDetailsVC.swift
//  BKI
//
//  Created by sreenivasula reddy on 20/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import UIKit

class HangerDashBoardDetailsVC: BaseViewController
{
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var containerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var hangerViewState : HangersBoardState = HangersBoardState.none
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        detailTableView.registerReusableCell(AssembleTableViewCell.self)
        detailTableView.registerReusableCell(LabelTableViewCell.self)
        detailTableView.registerReusableHeaderFooterView(HangersheaderView.self)
        detailTableView.tableFooterView = UIView()
        
        self.detailTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        switch hangerViewState {
        case .cutRods:
            self.title = "Rod Cutting"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = "Zinc"
        case .cutStruts:
            self.title = "Unistrut Cutting"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = "Zinc"
        case .assemble:
            self.title = "Assemble"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = ""
        default:
            self.title = ""
            packageLabel.text = ""
            materialLabel.text = ""
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        containerViewWidth.constant = detailTableView.contentSize.width
        containerViewHeight.constant = detailTableView.contentSize.height
        var tableFrame = detailTableView.frame
        tableFrame.size.height = detailTableView.contentSize.height;
        tableFrame.size.width = detailTableView.contentSize.width; // if you would allow horiz scrolling
        detailTableView.frame = tableFrame;
        UIView.animate(withDuration: 0.01) {
            DispatchQueue.main.async { [weak self] in
                   self?.view?.updateConstraints()
                    self?.view?.layoutIfNeeded()
            }
        }
    }
}

//MARK:- UITableViewDataSource methods
extension HangerDashBoardDetailsVC:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        switch hangerViewState {
        case .cutRods:
            return 3
        case .cutStruts:
            return 4
        case .assemble:
            return 1
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch hangerViewState {
        case .cutRods,.cutStruts:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as LabelTableViewCell
            cell.nameLabel.text = "row \(indexPath.row)"
            cell.backgroundColor = .clear
            return cell
        case .assemble:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as AssembleTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch hangerViewState {
        case .cutRods:
            let v:HangersheaderView? = tableView.dequeueReusableHeaderFooterView()
            v?.labelOne?.text = "Nest Bundle \(section+1)"
            v?.labelTwo?.text = "Size: \(section+1)/8"
            v?.labelThree?.text = "No REQ: \(section+3)"
            v?.completedButton.tag = section
            v?.completedButton.addTarget(self, action: #selector(didTapSection), for: .touchUpInside)
            return v
        case .cutStruts:
            let v:HangersheaderView? = tableView.dequeueReusableHeaderFooterView()
            v?.labelOne?.text = "Nest Bundle \(section+1)"
            v?.labelTwo?.text = "Description"
            v?.labelThree?.text = "No REQ: \(section+3)"
            v?.completedButton.tag = section
            v?.completedButton.addTarget(self, action: #selector(didTapSection), for: .touchUpInside)
            return v
        case .assemble:
            return nil
        default:
            return nil
        }
    }
    
    @objc fileprivate func didTapSection(sendr:UIButton)
    {
        self.alertVC.presentAlertWithTitleAndMessage(title: "Message", message: "You selected section \(sendr.tag)" , controller: self)
    }
}

//MARK:- UITableViewDelegate methods
extension HangerDashBoardDetailsVC:UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
}
