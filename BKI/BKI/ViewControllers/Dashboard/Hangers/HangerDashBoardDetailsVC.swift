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
    @IBOutlet weak var assembleCollectionView: UICollectionView!
    @IBOutlet weak var gridLayout: StickyGridCollectionViewLayout!{
        didSet
        {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 0
        }
    }
    
    var hangerViewState : HangersBoardState = HangersBoardState.none
    var headernames = ["Hanger No.","Size","Description","Rod length (A)","Rod length (M)","Rod Width (F)","Rod size","QTY","Comp"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        detailTableView.registerReusableCell(AssembleTableViewCell.self)
        detailTableView.registerReusableCell(LabelTableViewCell.self)
        detailTableView.registerReusableHeaderFooterView(HangersheaderView.self)
        detailTableView.tableFooterView = UIView()

        assembleCollectionView.registerReusableCell(LabelCollectionViewCell.self)
        assembleCollectionView.registerReusableCell(ButtonCollectionViewCell.self)
        assembleCollectionView.backgroundColor = .clear
            
        assembleCollectionView.isHidden = true
        detailTableView.isHidden = false
        
        switch hangerViewState {
        case .cutRods:
            self.title = "Rod Cutting"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = "Material: Zinc"
        case .cutStruts:
            self.title = "Unistrut Cutting"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = "Material: Zinc"
        case .assemble:
            self.title = "Assemble"
            packageLabel.text = "Package: Name of package"
            materialLabel.text = ""
            assembleCollectionView.isHidden = false
            detailTableView.isHidden = true
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
        switch hangerViewState {
        case .cutRods:
            return 3
        case .cutStruts:
            return 4
        case .assemble:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch hangerViewState {
        case .cutRods,.cutStruts:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as LabelTableViewCell
            cell.nameLabel.text = "row \(indexPath.row)"
            cell.backgroundColor = .clear
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

// MARK: - Collection view data source and delegate methods

extension HangerDashBoardDetailsVC: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return headernames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let labelcell = collectionView.dequeueReusableCell(indexPath: indexPath) as LabelCollectionViewCell
            labelcell.backgroundColor = .clear //gridLayout.isItemSticky(at: indexPath) ? UIColor.arcColor() : .clear
            labelcell.nameLabel.text =  headernames[indexPath.row]
            return labelcell
        }
        else
        {
            if (indexPath.row == collectionView.numberOfItems(inSection: indexPath.section)-1)
            {
                let buttoncell = collectionView.dequeueReusableCell(indexPath: indexPath) as ButtonCollectionViewCell
                buttoncell.backgroundColor = .clear
                return  buttoncell
            }
            else
            {
                let labelcell = collectionView.dequeueReusableCell(indexPath: indexPath) as LabelCollectionViewCell
                labelcell.backgroundColor = gridLayout.isItemSticky(at: indexPath) ? .red : .clear
                labelcell.nameLabel.text = "sec \(indexPath.section) row \(indexPath.row)"
                return labelcell
            }
        }
    }
}
extension HangerDashBoardDetailsVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 100)
    }
}
