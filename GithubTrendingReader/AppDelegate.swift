//
//  AppDelegate.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 13/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK - Initializers

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupUIAppareance()
        setupWindow()
        return true
    }
    
    func setupUIAppareance(){
        ClassHelper.setupUIAppareance(isDarkModeEnabled: Constants.isDarkModeEnabled)
    }
    
    func setupWindow(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationController.init(rootViewController: ViewController())
        window?.makeKeyAndVisible()
    }
}
