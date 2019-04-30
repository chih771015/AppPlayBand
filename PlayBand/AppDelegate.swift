//
//  AppDelegate.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseManger.shared.configure()
        Fabric.with([Crashlytics.self])
        // Override point for customization after application launch.
        let appdelgate = UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        if FirebaseManger.shared.user().currentUser != nil {
            
            let nextVC = UIStoryboard.main.instantiateInitialViewController()
            appdelgate.window?.rootViewController = nextVC
        } else {
            
            let nextVC = UIStoryboard.signIn.instantiateInitialViewController()
            appdelgate.window?.rootViewController = nextVC
        }
        IQKeyboard.shared.frameworkAction()
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

}
