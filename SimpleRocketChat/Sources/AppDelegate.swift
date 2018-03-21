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
        func afterAuthentication() {
            if let auth = AuthManager.isAuthenticated() {
                AuthManager.persistAuthInformation(auth)
                AuthSettingsManager.shared.updateCachedSettings()
                self.showChatViewController()
            }
        }
        if AuthManager.isAuthenticated() == nil {
            self.setupAuthManager() {
                afterAuthentication()
            }
        } else {
            afterAuthentication()
        }
        
        return true
    }
}

// MARK: - Routines
extension AppDelegate {
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func showChatViewController() {
        self.window?.rootViewController = UINavigationController(rootViewController: ChatViewController.instantiate())
    }
}

// MARK: - Sign In
extension AppDelegate {
    
    func setupAuthManager(_ completion: (()->())?) {
        // Authentication
        let auth = Auth()
        auth.lastSubscriptionFetch = nil
        auth.lastAccess = Date()
        auth.serverURL = "wss://test-im.soyou.io/websocket"
        auth.token = "01UzMuqCz06NtTPb1qgTTs-lfxXU6uYx4MEMWhgsqkj"
        auth.userId = "czfJCwRY3gqSi5LuN"
        
        AuthManager.persistAuthInformation(auth)
        DatabaseManager.changeDatabaseInstance()
        
        Realm.executeOnMainThread({ (realm) in
            // Delete all the Auth objects, since we don't
            // support multiple-server per database
            realm.delete(realm.objects(Auth.self))
            
            //            PushManager.updatePushToken()
            realm.add(auth)
        })
        
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
