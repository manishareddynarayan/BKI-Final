//
//  AppDelegate.swift
//  BKI
//
//  Created by srachha on 11/09/18.
//  Copyright © 2018 srachha. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.brickRed
        UINavigationBar.appearance().tintColor = UIColor.white
        Fabric.with([Crashlytics.self])
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

    func setupRootViewController() {
        let defs = BKIModel.initUserdefsWithSuitName()//
        let(storyBoard,identifier) = (defs?.bool(forKey: "isLoggedIn"))!
            ? ("Main","MainDashBoardNVC") : ("Auth","LoginVC")
        self.setInitialViewController(storyBoardName: storyBoard, identifier: identifier)
    }
    
    func setInitialViewController(storyBoardName:String,identifier:String) {
        let storyboard1 = UIStoryboard.init(name:storyBoardName , bundle: nil)
        weak var vc = (storyboard1.instantiateViewController(withIdentifier: identifier) )
        self.window?.rootViewController = vc
    }
    
    func application(_ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask,
                andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}
