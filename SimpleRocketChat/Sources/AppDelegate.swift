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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Disable constaint error log
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // Setup window
        self.setupWindow()
        
        // Setup AuthManager
        self.setupAuthManager() {
            self.showHomeViewController()
            
            // Try create a direct message
            func createDirectMessage() {
                AppManager.openDirectMessage(username: "jiyun") {
                    if let chatVC = ChatViewController.shared {
                        (self.window?.rootViewController as? UINavigationController)?.pushViewController(chatVC, animated: true)
                    }
                }
            }
            if !SocketManager.isConnected() {
                SocketManager.reconnect({
                    createDirectMessage()
                })
            } else {
                createDirectMessage()
            }
        }
        
        return true
    }
    
    // MARK: AppDelegate LifeCycle
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SubscriptionManager.updateUnreadApplicationBadge()
        
        if AuthManager.isAuthenticated() != nil {
            UserManager.setUserPresence(status: .away) { (_) in
                SocketManager.disconnect({ (_, _) in })
            }
        }
    }
    
    // MARK: Remote Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserDefaults.standard.set(deviceToken.hexString, forKey: PushManager.kDeviceTokenKey)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.debug("Fail to register for notification: \(error)")
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

// MARK: - Sign In
extension AppDelegate {
    
    func setupAuthManager(_ completion: (()->())?) {
        // Authentication
        var auth = Auth()
        
        if let oldAuth = AuthManager.isAuthenticated() {
            auth = oldAuth
        } else {
            auth.lastSubscriptionFetch = nil
            auth.lastAccess = Date()
            auth.serverURL = "wss://test-im.soyou.io/websocket"
            auth.token = "gj3ef2ijsOs7sxir7iPf-8NVSNGeIxeCjVMSFUEAoZ1"
            auth.userId = "JAqNKpngJ8ub4egBM"
            
            Realm.executeOnMainThread({ (realm) in
                // Delete all the Auth objects, since we don't
                // support multiple-server per database
                realm.delete(realm.objects(Auth.self))
                
                //            PushManager.updatePushToken()
                realm.add(auth)
            })
        }
        
        AuthManager.persistAuthInformation(auth)
        DatabaseManager.changeDatabaseInstance()
        
        if let socketURL = URL(string: "wss://test-im.soyou.io/websocket") {
            if SocketManager.isConnected() {
                self.updateSettings(auth, completion)
            } else {
                SocketManager.connect(socketURL) { (_, connected) in
                    if connected {
                        self.updateSettings(auth, completion)
                    }
                }
            }
        }
    }
    
    func updateSettings(_ auth: Auth, _ completion: (()->())?) {
        AuthSettingsManager.updatePublicSettings(auth, completion: { _ in
            SocketManager.disconnect({ (_, _) in
                completion?()
            })
        })
    }
}
