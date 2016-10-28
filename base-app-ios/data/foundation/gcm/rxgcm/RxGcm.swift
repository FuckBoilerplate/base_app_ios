//
//  RxGcm.swift
//  RxGcm
//
//  Created by Roberto Frontado on 2/16/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import Google

open class RxGcm: NSObject, GGLInstanceIDDelegate {
    
    open static let Notifications = RxGcm()
    
    fileprivate var connectedToGCM = false
    fileprivate var subscribedToTopic = false
    fileprivate var gcmSenderID: String?
    fileprivate var registrationToken: String?
    fileprivate var registrationOptions = [String: AnyObject]()
    
    fileprivate let subscriptionTopic = "/topics/global"
    
    fileprivate var onBackground = false
    
    static let RX_GCM_KEY_TARGET = "rx_gcm_key_target" // VisibleForTesting
    static let RX_GCM_KEY_FROM = "rx_gcm_key_from"
    
    fileprivate var persistence: Persistence!
    fileprivate var getGcmReceiversUIForeground: GetGcmReceiversUIForeground!
    fileprivate var mainThreadScheduler: SchedulerType!
    fileprivate var backgroundThreadScheduler: SchedulerType!
    fileprivate var testing: Bool = false
    
    func initForTesting(_ onBackground: Bool, registrationToken: String?, persistence: Persistence, getGcmReceiversUIForeground: GetGcmReceiversUIForeground) {
        self.testing = true
        self.registrationToken = registrationToken
        self.persistence = persistence
        self.getGcmReceiversUIForeground = getGcmReceiversUIForeground
        self.onBackground = onBackground
    }
    
    override init() {
        super.init()
        persistence = Persistence()
        getGcmReceiversUIForeground = GetGcmReceiversUIForeground()
        mainThreadScheduler = MainScheduler.instance
        backgroundThreadScheduler = SerialDispatchQueueScheduler(qos: .background)
    }
    
    open func isAppOnBackground() -> Bool {
        return onBackground
    }
    
    open func register<T: GcmReceiverData, U: GcmReceiverUIBackground>(_ gcmReceiverClass: T.Type, gcmReceiverUIBackgroundClass: U.Type) -> Observable<String> {
        
        return Observable<String>.create { (observable) -> Disposable in
            self.persistence.saveClassNameGcmReceiverAndGcmReceiverUIBackground(String(describing:gcmReceiverClass), gcmReceiverUIBackgroundClassName: String(describing:gcmReceiverUIBackgroundClass))
            
            if let _ = self.persistence.getToken() {
                observable.onCompleted()
                return Disposables.create()
            }
        
            if let token = self.registrationToken {
                self.persistence.saveToken(token)
                observable.onNext(token)
                observable.onCompleted()
                return Disposables.create()
            }
            
            observable.onError(NSError(domain: Constants.ERROR_TOKEN_IS_MISSING, code: 0, userInfo: nil))
            observable.onCompleted()
            return Disposables.create()
            }.subscribeOn(backgroundThreadScheduler)
            .delaySubscription(3, scheduler: backgroundThreadScheduler)
            .retry(3)
            .observeOn(mainThreadScheduler)
    }
    
    /**
    * @return Current token associated with the device on Google Cloud Messaging serve.
    */
    open func currentToken() -> Observable<String> {
        return Observable.create({ (observable) -> Disposable in
            if let token = self.persistence.getToken() {
                observable.onNext(token)
            } else {
                observable.onError(NSError(domain: Constants.ERROR_NOT_CACHED_TOKEN_AVAILABLE, code: 0, userInfo: nil))
            }
            observable.onCompleted()
            return Disposables.create()
        }).subscribeOn(backgroundThreadScheduler)
            .observeOn(mainThreadScheduler)
    }
    /**
    * @param aClass The class which implements GcmRefreshTokenReceiver and so the class which will be notified when a token refresh happens.
    * @see GcmRefreshTokenReceiver
    */
     
    open func onRefreshToken<T: GcmRefreshTokenReceiver>(_ gcmRefreshTokenReceiverClass: T.Type) {
        persistence.saveClassNameGcmRefreshTokenReceiver(String(describing: gcmRefreshTokenReceiverClass))
    }
    
    open func onTokenRefreshed() {
        if let className = persistence.getClassNameGcmRefreshTokenReceiver() {
            let tokenReceiver: GcmRefreshTokenReceiver = getInstanceClassByName(className)
            if let token = registrationToken {
                let tokenUpdate = TokenUpdate(token: token)
                tokenReceiver.onTokenReceive(Observable.just(tokenUpdate))
            } else {
                tokenReceiver.onTokenReceive(Observable.error(NSError(domain: Constants.ERROR_GCM_NOT_AVAILABLE, code: 0, userInfo: nil)))
            }
        }
    }
    
    open func onNotificationReceived(_ data: [AnyHashable: Any]) {
        print("Notification received: \(data)")
        
        let target = data[RxGcm.RX_GCM_KEY_TARGET] as? String ?? ""
        // Not sure about this
        let from = data[RxGcm.RX_GCM_KEY_FROM] as? String ?? ""
        
        let oMessage = Observable.just(RxMessage(from: from, payload: data, target: target))
        if let className = persistence.getClassNameGcmReceiver() {
            let gcmReceiverData: GcmReceiverData = getInstanceClassByName(className)
            
            gcmReceiverData.onNotification(oMessage)
                .subscribe(onNext:  { message in
                    if self.isAppOnBackground() {
                        self.notifyGcmReceiverBackgroundMessage(message)
                    } else {
                        self.notifyGcmReceiverForegroundMessage(message)
                    }
            })
        }
    }

    fileprivate func notifyGcmReceiverBackgroundMessage(_ message: RxMessage) {
        
        if let className = persistence.getClassNameGcmReceiverUIBackground() {
            let gcmReceiverUIBackground: GcmReceiverUIBackground = getInstanceClassByName(className)
            
            let oNotification = Observable.just(message).observeOn(mainThreadScheduler)
            gcmReceiverUIBackground.onNotification(oNotification)
        }
    }
    
    fileprivate func notifyGcmReceiverForegroundMessage(_ message: RxMessage) {
        
        if let wrapperGcmReceiverUIForeground = getGcmReceiversUIForeground.retrieve(message.getTarget()) {
            
            let oNotification = Observable.just(message).observeOn(mainThreadScheduler)
            
            if wrapperGcmReceiverUIForeground.targetScreen {
                wrapperGcmReceiverUIForeground.gcmReceiverUIForeground
                    .onTargetNotification(oNotification)
            } else {
                wrapperGcmReceiverUIForeground.gcmReceiverUIForeground
                    .onMismatchTargetNotification(oNotification)
            }
        }
    }
    
    fileprivate func getClassByName(_ className: String) -> AnyClass? {
        return NSClassFromString(className)
    }
    
    open func getInstanceClassByName<T>(_ className: String) -> T {
        var instance: AnyObject! = nil
        var bundle = Bundle(for: RxGcm.self).infoDictionary!["CFBundleExecutable"] as! String
        if testing {
            // Limitation
            bundle = "\(bundle)Tests"
        }
        bundle = bundle.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_")
        let classInst = getClassByName("\(bundle).\(className)") as! NSObject.Type
        instance = classInst.init()
        return instance as! T
    }
    
    // MARK: - GCM Methods
    fileprivate func registrationHandler(_ registrationToken: String?, error: Error?) {
        if let registrationToken = registrationToken {
            print("Registration Token: \(registrationToken)")
            self.registrationToken = registrationToken
            persistence.saveToken(registrationToken)
            subscribeToTopic()
            onTokenRefreshed()
        } else {
            print("Registration to GCM failed with error: \(error?.localizedDescription)")
        }
    }
    
    fileprivate func subscribeToTopic() {
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error) -> Void in
                    if let error = error {
                        print("Subscription failed: \(error.localizedDescription)")
                    } else {
                        self.subscribedToTopic = true
                        print("Subscribed to \(self.subscriptionTopic)")
                    }
            })
        }
    }
    
    @objc open  func onTokenRefresh() {
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID!,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    // MARK: - AppDelegate Methods
    open func didFinishLaunchingWithOptions(_ application: UIApplication, launchOptions: [AnyHashable: Any]?) {
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        let types: UIUserNotificationType = [.badge, .alert, .sound]
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( types: types, categories: nil )
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        let gcmConfig = GCMConfig.default()
        // TODO: - Implement receiver delegate!!!
//        gcmConfig.receiverDelegate = appGCMReceiverDelegate
        GCMService.sharedInstance().start(with: gcmConfig)
    }
    
    
    open func didRegisterForRemoteNotificationsWithDeviceToken(_ application: UIApplication, deviceToken: Data) {
        print("Did register for remote notification with device toke: \(deviceToken)")
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true as AnyObject]
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                                                 scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    open func didFailToRegisterForRemoteNotificationsWithError(_ application: UIApplication, error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    
    open func didReceiveRemoteNotification(_ application: UIApplication, userInfo: [AnyHashable: Any]) {
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        onNotificationReceived(userInfo)
    }
    
    open func didReceiveRemoteNotification(_ application: UIApplication,
                                             userInfo: [AnyHashable: Any],
                                             fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        onNotificationReceived(userInfo)
        handler(UIBackgroundFetchResult.noData)
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        onBackground = true
        
        GCMService.sharedInstance().disconnect()
        connectedToGCM = false
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
        onBackground = false
        
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connect(handler: { error -> Void in
            if let error = error {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
    }
}

