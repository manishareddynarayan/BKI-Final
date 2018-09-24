//
//  AppDelegate.swift
//  BKI
//
//  Created by srachha on 11/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.brickRed
        UINavigationBar.appearance().tintColor = UIColor.white
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func setupRootViewController() -> Void{
        let defs = BKIModel.initUserdefsWithSuitName()//
        let(storyBoard,identifier) = (defs?.bool(forKey: "isLoggedIn"))! ? ("Main","MainDashBoardNVC") : ("Auth","LoginVC")
        self.setInitialViewController(storyBoardName: storyBoard, identifier: identifier)
    }
    
    func setInitialViewController(storyBoardName:String,identifier:String) -> Void {
        let storyboard1 = UIStoryboard.init(name:storyBoardName , bundle: nil)
        weak var vc = (storyboard1.instantiateViewController(withIdentifier: identifier) )
        self.window?.rootViewController = vc
    }

}

