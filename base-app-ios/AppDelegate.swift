//
//  AppDelegate.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func setupAppBar() {
        
        let colorBlueLight = UIColor.colorBlueLight()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(colorBlueLight), for: UIBarMetrics.default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        R.assertValid()
        setupAppBar()
        
        // RxGcm setup
//        RxGcm.Notifications.register(GcmMessageReceiver.self, gcmReceiverUIBackgroundClass: GcmBackgroundReceiver.self)
//            .subscribe(
//                onNext: { token in GcmTokenReceiver().onTokenReceive(Observable.just(TokenUpdate(token: token))) },
//                onError: { error in  print("RxGcm configuration failed") }
//        )
//        
//        RxGcm.Notifications.onRefreshToken(GcmTokenReceiver.self)
        
        return true
    }

}

