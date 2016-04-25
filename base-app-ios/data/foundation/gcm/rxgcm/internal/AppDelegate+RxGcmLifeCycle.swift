//
//  AppDelegate+RxGcmLifeCycle.swift
//  RxGcm
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

var appDelegate: UIApplicationDelegate.Type?

extension UIResponder {
    
    override public class func initialize() {
        
        if !(self is UIApplication.Type) {
            return
        }
        
        guard let bundle = NSBundle.mainBundle().infoDictionary?["CFBundleExecutable"] as? String else {
            return
        }
        
        var appDelegateClass: NSObject.Type!
        
        if let delegateClass = NSClassFromString("\(bundle).AppDelegate") as? NSObject.Type {
            appDelegateClass = delegateClass
        }
        
        if let userAppDelegateClass = appDelegate as? NSObject.Type {
            appDelegateClass = userAppDelegateClass
        }
        
        if appDelegateClass == nil {
            return
        }
        
        // Change methods implementations
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "application:didFinishLaunchingWithOptions:",
            rxgcmSelector: "rxgcm_application:didFinishLaunchingWithOptions:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "application:didRegisterForRemoteNotificationsWithDeviceToken:",
            rxgcmSelector: "rxgcm_application:didRegisterForRemoteNotificationsWithDeviceToken:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "application:didFailToRegisterForRemoteNotificationsWithError:",
            rxgcmSelector: "rxgcm_application:didFailToRegisterForRemoteNotificationsWithError:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "application:didReceiveRemoteNotification:",
            rxgcmSelector: "rxgcm_application:didReceiveRemoteNotification:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "application:didReceiveRemoteNotification:fetchCompletionHandler:",
            rxgcmSelector: "rxgcm_application:didReceiveRemoteNotification:fetchCompletionHandler:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "applicationDidBecomeActive:",
            rxgcmSelector: "rxgcm_applicationDidBecomeActive:"
        )
        changeMethodImplementation(
            appDelegateClass,
            originalSelector: "applicationDidEnterBackground:",
            rxgcmSelector: "rxgcm_applicationDidEnterBackground:"
        )
    }
    
    class func changeMethodImplementation<T: NSObject>(appDelegateClass: T.Type, originalSelector: String, rxgcmSelector: String) {
        
        let originalSelector = Selector(originalSelector)
        let rxgcmSelector = Selector(rxgcmSelector)
        
        let originalMethod = class_getInstanceMethod(appDelegateClass, originalSelector)
        let rxgcmMethod = class_getInstanceMethod(appDelegateClass, rxgcmSelector)
        
        let didAddMethod = class_addMethod(appDelegateClass, originalSelector, method_getImplementation(rxgcmMethod), method_getTypeEncoding(rxgcmMethod))
        
        if didAddMethod {
            class_replaceMethod(appDelegateClass, rxgcmSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, rxgcmMethod)
        }
        
    }
    
    // MARK: - New Methods Implementations
    
    internal func rxgcm_application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("rxgcm_applicationdidFinishLaunchingWithOptions")
        self.rxgcm_application(application, didFinishLaunchingWithOptions: launchOptions)
        RxGcm.Notifications.didFinishLaunchingWithOptions(application, launchOptions: launchOptions)
        return true
    }
    internal func rxgcm_application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
        print("rxgcm_applicationdidRegisterForRemoteNotificationsWithDeviceToken")
        self.rxgcm_application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        RxGcm.Notifications.didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken: deviceToken)
    }
    
    internal func rxgcm_application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
            print("rxgcm_applicationdidFailToRegisterForRemoteNotificationsWithError")
            self.rxgcm_application(application, didFailToRegisterForRemoteNotificationsWithError: error)
            RxGcm.Notifications.didFailToRegisterForRemoteNotificationsWithError(application, error: error)
    }
    
    internal func rxgcm_application(application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            print("rxgcm_applicationdidReceiveRemoteNotification")
            self.rxgcm_application(application, didReceiveRemoteNotification: userInfo)
            RxGcm.Notifications.didReceiveRemoteNotification(application, userInfo: userInfo)
    }
    
    internal func rxgcm_application(application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
            print("rxgcm_applicationdidReceiveRemoteNotificationfetchCompletionHandler")
            self.rxgcm_application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: handler)
            RxGcm.Notifications.didReceiveRemoteNotification(application, userInfo: userInfo, fetchCompletionHandler: handler)
    }
    
    internal func rxgcm_applicationDidEnterBackground(application: UIApplication) {
        print("rxgcm_applicationDidEnterBackground")
        self.rxgcm_applicationDidEnterBackground(application)
        RxGcm.Notifications.applicationDidEnterBackground(application)
    }
    
    internal func rxgcm_applicationDidBecomeActive(application: UIApplication) {
        print("rxgcm_applicationDidBecomeActive")
        self.rxgcm_applicationDidBecomeActive(application)
        RxGcm.Notifications.applicationDidBecomeActive(application)
    }
    
}

// MARK: - Defaults methods implementations
extension UIResponder {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
    }
    
    func application(application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    }
    
    func application(application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
        fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
}