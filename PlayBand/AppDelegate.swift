//
//  AppDelegate.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/2.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseSingle.shared.configure()
        FirebaseSingle.shared.listenAccount { (auth, user) in
            guard let appdelgate = UIApplication.shared.delegate as? AppDelegate  else { return }
            
                        guard user != nil else {
            
                            let nextVC = UIStoryboard.signIn.instantiateInitialViewController()
                            appdelgate.window?.rootViewController = nextVC
                            return
                        }
            
                        let nextVC = UIStoryboard.main.instantiateInitialViewController()
                        appdelgate.window?.rootViewController = nextVC
        }
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
