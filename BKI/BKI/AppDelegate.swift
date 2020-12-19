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
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.brickRed
        UINavigationBar.appearance().tintColor = UIColor.white
        //        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        timer.invalidate()
        let dd = Date().endOfDay
        timer = Timer(fire: dd!, interval: 0, repeats: false) { (timer) in
            self.runCode()
        }
        RunLoop.main.add(timer, forMode: .common)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let topVC = UIApplication.getTopViewController() {
            topVC.viewDidLoad()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.removeObject(forKey: "truck_number")
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
    func runCode() {
        //to logout at 12
        //        BKIModel.resetUserDefaults()
        //        self.appDelegate?.setupRootViewController()
        let now = NSDate()
        let nowDateValue = now as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nowDateValue)
        let fullMinuteDate = calendar.date(from: components)!
        let date = Date().getEndOfTheDay()
        let currentDate = dateFormatter.string(from: fullMinuteDate)
        let finalAlarmDate = dateFormatter.string(from: date)
        if currentDate == finalAlarmDate {
            BKIModel.resetUserDefaults()
            self.setupRootViewController()
        }
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
