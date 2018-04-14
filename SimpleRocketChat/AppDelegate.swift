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
                          userId: "W29Buw6gktnkqkZ3s",
                          token: "kFv6U1eSViawlrohYyx56OJsjWGoduC7LimxKVzKR4Y") { success in
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if RocketChatManager.handleDeepLink(url, completion: { self.showChatViewController() }) {
            return true
        }
        return false
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
        if let navC = self.window?.rootViewController as? UINavigationController,
            let chatVC = ChatViewController.shared,
            navC.topViewController != chatVC {
            navC.pushViewController(chatVC, animated: true)
        }
    }
}
