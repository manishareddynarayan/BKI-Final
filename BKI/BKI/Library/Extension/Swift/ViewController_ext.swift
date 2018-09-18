//
//  ViewController_ext.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 21/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func storyBoard() -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:"Main" , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifier(identifier:String) -> UIViewController {
        
        let sb = self.storyBoard()
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    func pushViewControllerWithIdentifier(identifier:String) -> Void {
        let vc = self.getViewControllerWithIdentifier(identifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Multiple Storyboards
    func storyBoardWithName(name:String) -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:name , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> UIViewController {
        
        let sb = self.storyBoardWithName(name: storyBoard)
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    func pushViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> Void
    {
        let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier: identifier,storyBoard: storyBoard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func removeChildViewController() -> Void {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    func present(childVC:UIViewController) -> Void {
        self.addChildViewController(childVC)
        self.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
    }
    
    
    func applyTintColorForLeftBarButtonWith(color:UIColor)  {
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    
    func applyTintColorForRightBarButtonWith(color:UIColor)  {
        self.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
    
    func deviceWidth() -> CGFloat {
        
        let  width  = UIScreen.main.bounds.size.width
        
        return width
    }
    
    
    func deviceHeight() -> CGFloat {
        
        let  height  = UIScreen.main.bounds.size.height
        
        return height
    }
    
    
    func deviceSize() -> CGSize {
        
        let  size  = UIScreen.main.bounds.size
        
        return size
    }
    
    
    func getStringFromSelectedDate(date:NSDate) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY h:mm:ss a"//"dd-MM-YYYY hh:mm a"
        let dateStr = formatter.string(from: date as Date)
        
        return dateStr;
    }
    
    
    func saveImageData(image: UIImage) {
        //let data : NSData = UIImagePNGRepresentation(image)!
        let data : NSData = UIImageJPEGRepresentation(image, 0.1)! as NSData
        let defs = UserDefaults(suiteName: "group.com.priceit.app")
        defs?.set(data, forKey: "userPic")
        defs?.synchronize()
    }
    
    
    func getProfilePic() -> UIImage! {
        
        var data: NSData? = nil
        let defs = UserDefaults(suiteName: "group.com.Procept.app")
        data  = defs?.object(forKey: "userPic") as? NSData
     
        if (data != nil)
        {
            let image = UIImage.init(data: data! as Data)
            return image
        }
        return nil
    }
    
    
    //MARK:---- Navigation back
    func setBackBarButton() -> Void {
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "backArrow"), style: UIBarButtonItemStyle.plain, target: self, action: (#selector(self.popViewController)))
        backItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func popViewController()  {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func setNavigationTitleViewWith(imageName:String) -> Void {
       
        let titleView = UIImageView.init(image: UIImage.init(named: imageName))
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
        
    }
    
    
    func setNavigationTitleViewWithSearchBar() -> UISearchBar {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Find you favourite products.."
        self.navigationItem.titleView = searchBar
        return searchBar
        
    }
}


