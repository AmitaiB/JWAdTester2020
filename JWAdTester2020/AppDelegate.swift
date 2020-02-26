//
//  AppDelegate.swift
//  JWAdTester2020
//
//  Created by Amitai Blickstein on 1/26/20.
//  Copyright © 2020 JWPlayer. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import KeychainSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        if let storedLicense = keychain.get(L10n.licenseKey) {
            JWPlayerController.setPlayerKey(storedLicense)
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        (window?.rootViewController as? MainViewController)?.saveToDefaults()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        (window?.rootViewController as? MainViewController)?.syncToDefaults()
    }
}

public let keychain: KeychainSwift = {
    let kChain = KeychainSwift()
    kChain.synchronizable = true
    kChain.accessGroup = L10n.comJwplayerJWAdTester2020
    return kChain
}()
