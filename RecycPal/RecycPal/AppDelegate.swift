//
//  AppDelegate.swift
//  RecycPal
//
//  Created by Justin Esguerra on 1/15/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // View controllers
        window?.backgroundColor = Colors.green
        
        let main = HomeTabViewController()
        
        let navVC = UINavigationController(rootViewController: main)
        window?.rootViewController = navVC
        
        return true
    }
}

