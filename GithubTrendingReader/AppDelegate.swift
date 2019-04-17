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

    // MARK: - Custom Functions

    func switchMode(_   animated: Bool = true,
                    duration: TimeInterval = 0.5,
                    options: UIView.AnimationOptions = .transitionFlipFromBottom,
                    completion: (() -> Void)? = nil) {
        guard let window = window else { return }
        setupUIAppareance()
        let rootViewController = NavigationController.init(rootViewController: ViewController())
        guard animated else {
            window.rootViewController = rootViewController
            return
        }
        UIView.transition(with: window, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = rootViewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}







extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

