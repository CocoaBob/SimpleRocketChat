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
        self.setupWindow()
        self.setupViewControllers()
        
        // Setup Server
        if let socketURL = URL(string: "wss://test-im.soyou.io/websocket") {
            SocketManager.connect(socketURL) { (_, connected) in
                if !connected {
                    return
                }
                let index = DatabaseManager.createNewDatabaseInstance(serverURL: socketURL.absoluteString)
                DatabaseManager.changeDatabaseInstance(index: index)
            }
        }
        
        // Authentication
        let auth = Auth()
        auth.lastSubscriptionFetch = nil
        auth.lastAccess = Date()
        auth.serverURL = "wss://test-im.soyou.io/websocket"
        auth.token = "nuHmOkGONNBzzUz-5PuxajQglfbWTA-N6ah-Sn92VK2"
        auth.userId = "SSEfYBzcWnXpr8FG3"
        
        AuthManager.persistAuthInformation(auth)
        DatabaseManager.changeDatabaseInstance()
        
        Realm.executeOnMainThread({ (realm) in
            // Delete all the Auth objects, since we don't
            // support multiple-server per database
            realm.delete(realm.objects(Auth.self))
            
//            PushManager.updatePushToken()
            realm.add(auth)
        })
        
        SocketManager.sharedInstance.isUserAuthenticated = true
        ServerManager.timestampSync()
        return true
    }
}

// MARK: - Routines
extension AppDelegate {
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
    }
    
    func setupViewControllers() {
        self.window?.rootViewController = UINavigationController(rootViewController: ChatViewController.instantiate())
    }
}
