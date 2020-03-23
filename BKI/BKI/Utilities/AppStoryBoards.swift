//
//  AppStoryBoards.swift
//  BKI
//
//  Created by sreenivasula reddy on 23/03/20.
//  Copyright © 2020 srachha. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String
{
    case Main = "Main"
    case Root = "Root"
    case Auth = "Auth"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T
    {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController?
    {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController
{
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String { return "\(self)" }
    static func instantiate(from appStoryboard: AppStoryboard) -> Self
    {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    static func initialViewController(from appStoryboard: AppStoryboard) -> Self
    {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
