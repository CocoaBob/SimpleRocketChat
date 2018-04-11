//
//  AppDelegate.swift
//  SimpleRocketChat
//
//  Created by CocoaBob on 2018-03-18.
//  Copyright © 2018 CocoaBob. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Disable constaint error log
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // Setup window
        self.setupWindow()
        
        RocketChatManager.appDidFinishLaunchingWithOptions(launchOptions)
        
        // Setup AuthManager
        RocketChatManager.signIn(socketServerAddress: "wss://test-im.soyou.io/websocket",
                          userId: "JWR67MfWMyKvyN2Yf",
                          token: "dn7UuUq1-8Y9e0MGYM_snIONP2N95VhUoKfB8S68Q5w") { success in
            self.showHomeViewController()
            
//            // Try create a direct message
//            func createDirectMessage() {
//                RocketChatManager.openDirectMessage(username: "jiyun") {
//                    if let chatVC = ChatViewController.shared {
//                        (self.window?.rootViewController as? UINavigationController)?.pushViewController(chatVC, animated: true)
//                    }
//                }
//            }
//            if !SocketManager.isConnected() {
//                SocketManager.reconnect({
//                    createDirectMessage()
//                })
//            } else {
//                createDirectMessage()
//            }
        }
        
        return true
    }
    
    // MARK: AppDelegate LifeCycle
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        RocketChatManager.appDidBecomeActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        RocketChatManager.appDidEnterBackground()
    }
    
    // MARK: Remote Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        RocketChatManager.appDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        RocketChatManager.appDidFailToRegisterForRemoteNotificationsWithError(error)
    }
}

// MARK: - Routines
extension AppDelegate {
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func showHomeViewController() {
        if let vc = SubscriptionsViewController.shared {
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
    
    func showChatViewController() {
        if let vc = ChatViewController.shared {
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
}
