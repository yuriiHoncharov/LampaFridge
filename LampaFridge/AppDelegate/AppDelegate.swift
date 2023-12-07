//
//  AppDelegate.swift
//  LampaFrig
//
//  Created by Yurii Honcharov on 01.12.2023.
//

import UIKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = RootViewController.fromStoryboard
        let navigationController = UINavigationController(rootViewController: rootViewController)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

