 //
//  RxGcm.swift
//  base_ios_app
//
//  Created by Roberto Frontado on 2/16/16.
//  Copyright © 2016 jaime. All rights reserved.
//

import RxSwift
import Google

public class RxGcm: NSObject, GGLInstanceIDDelegate {
    
    public static let Notifications = RxGcm()
    
    private var connectedToGCM = false
    private var subscribedToTopic = false
    private var gcmSenderID: String?
    private var registrationToken: String?
    private var registrationOptions = [String: AnyObject]()
    
    private let subscriptionTopic = "/topics/global"
    
    private var onBackground = false
    
    static let RX_GCM_KEY_TARGET = "rx_gcm_key_target" // VisibleForTesting
    static let RX_GCM_KEY_FROM = "rx_gcm_key_from"
    
    private var persistence: Persistence!
    private var getGcmReceiversUIForeground: GetGcmReceiversUIForeground!
    private var mainThreadScheduler: ImmediateSchedulerType!
    private var backgroundThreadScheduler: ImmediateSchedulerType!
    private var testing: Bool = false
    
    func initForTesting(onBackground: Bool, registrationToken: String?, persistence: Persistence, getGcmReceiversUIForeground: GetGcmReceiversUIForeground) {
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
        backgroundThreadScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    }
    
    public func isAppOnBackground() -> Bool {
        return onBackground
    }
    
    public func register<T: GcmReceiverData, U: GcmReceiverUIBackground>(gcmReceiverClass: T.Type, gcmReceiverUIBackgroundClass: U.Type) -> Observable<String> {
        
        return Observable<String>.create { (observable) -> Disposable in
            self.persistence.saveClassNameGcmReceiverAndGcmReceiverUIBackground(String(gcmReceiverClass), gcmReceiverUIBackgroundClassName: String(gcmReceiverUIBackgroundClass))
            
            if let _ = self.persistence.getToken() {
                observable.onCompleted()
                return NopDisposable.instance
            }
        
            if let token = self.registrationToken {
                self.persistence.saveToken(token)
                observable.onNext(token)
                observable.onCompleted()
                return NopDisposable.instance
            }
            
            observable.onError(NSError(domain: Constants.ERROR_TOKEN_IS_MISSING, code: 0, userInfo: nil))
            observable.onCompleted()
            return NopDisposable.instance
            }.subscribeOn(backgroundThreadScheduler)
        .observeOn(mainThreadScheduler)
        // TODO: - Add retryWhen
    }
    
    /**
    * @return Current token associated with the device on Google Cloud Messaging serve.
    */
    public func currentToken() -> Observable<String> {
        return Observable.create({ (observable) -> Disposable in
            if let token = self.persistence.getToken() {
                observable.onNext(token)
            } else {
                observable.onError(NSError(domain: Constants.ERROR_NOT_CACHED_TOKEN_AVAILABLE, code: 0, userInfo: nil))
            }
            observable.onCompleted()
            return NopDisposable.instance
        }).subscribeOn(backgroundThreadScheduler)
        .observeOn(mainThreadScheduler)
            // TODO: - Add retryWhen
    }
    /**
    * @param aClass The class which implements GcmRefreshTokenReceiver and so the class which will be notified when a token refresh happens.
    * @see GcmRefreshTokenReceiver
    */
     
    public  func onRefreshToken<T: GcmRefreshTokenReceiver>(gcmRefreshTokenReceiverClass: T.Type) {
        persistence.saveClassNameGcmRefreshTokenReceiver(String(gcmRefreshTokenReceiverClass))
    }
    
    public func onTokenRefreshed() {
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
    
    public func onNotificationReceived(data: [NSObject : AnyObject]) {
        print("Notification received: \(data)")
        
        let target = data[RxGcm.RX_GCM_KEY_TARGET] as? String ?? ""
        // Not sure about this
        let from = data[RxGcm.RX_GCM_KEY_FROM] as? String ?? ""
        
        let oMessage = Observable.just(RxMessage(from: from, payload: data, target: target))
        if let className = persistence.getClassNameGcmReceiver() {
            let gcmReceiverData: GcmReceiverData = getInstanceClassByName(className)
            gcmReceiverData.onNotification(oMessage)
                .doOn(onNext: { (message) -> Void in
                    if self.isAppOnBackground() {
                        self.notifyGcmReceiverBackgroundMessage(message)
                    } else {
                        self.notifyGcmReceiverForegroundMessage(message)
                    }
                }).subscribe()
        }
    }

    private func notifyGcmReceiverBackgroundMessage(message: RxMessage) {
        
        if let className = persistence.getClassNameGcmReceiverUIBackground() {
            let gcmReceiverUIBackground: GcmReceiverUIBackground = getInstanceClassByName(className)
            
            Observable.just(message).observeOn(mainThreadScheduler)
                .subscribe(onNext: { (message) -> Void in
                    let oNotification = Observable.just(message)
                    gcmReceiverUIBackground.onNotification(oNotification)
                })
        }
    }
    
    private func notifyGcmReceiverForegroundMessage(message: RxMessage) {
        
        if let wrapperGcmReceiverUIForeground = getGcmReceiversUIForeground.retrieve(message.getTarget()) {
            if wrapperGcmReceiverUIForeground.targetScreen {
                Observable.just(message).observeOn(mainThreadScheduler)
                    .subscribeNext({ (message) -> Void in
                        wrapperGcmReceiverUIForeground.gcmReceiverUIForeground
                            .onTargetNotification(Observable.just(message))
                    })
            } else {
                Observable.just(message).observeOn(mainThreadScheduler)
                    .subscribeNext({ (message) -> Void in
                        wrapperGcmReceiverUIForeground.gcmReceiverUIForeground
                            .onMismatchTargetNotification(Observable.just(message))
                    })
            }
        }
    }
    
    private func getClassByName(className: String) -> AnyClass? {
        return NSClassFromString(className)
    }
    
    public func getInstanceClassByName<T>(className: String) -> T {
        var instance: AnyObject! = nil
        var bundle = NSBundle(forClass: RxGcm.self).infoDictionary!["CFBundleExecutable"] as! String
        if testing {
            // Limitation
            bundle = "\(bundle)Tests"
        }
        let classInst = getClassByName("\(bundle).\(className)") as! NSObject.Type
        instance = classInst.init()
        return instance as! T
    }
    
    // MARK: - GCM Methods
    private func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            self.onTokenRefreshed()
        } else {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
        }
    }
    
    private func subscribeToTopic() {
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribeWithToken(self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(NSError error) -> Void in
                    if (error != nil) {
                        if error.code == 3001 {
                            print("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)")
                        }
                    } else {
                        self.subscribedToTopic = true
                        print("Subscribed to \(self.subscriptionTopic)")
                    }
            })
        }
    }
    
    @objc public  func onTokenRefresh() {
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID!,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    // MARK: - AppDelegate Methods
    public func didFinishLaunchingWithOptions(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        let types: UIUserNotificationType = [.Badge, .Alert, .Sound]
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        let gcmConfig = GCMConfig.defaultConfig()
        // TODO: - Implement receiver delegate!!!
//        gcmConfig.receiverDelegate = appGCMReceiverDelegate
        GCMService.sharedInstance().startWithConfig(gcmConfig)
    }
    
    public func didRegisterForRemoteNotificationsWithDeviceToken(application: UIApplication, deviceToken: NSData) {
        print("Did register for remote notification with device toke: \(deviceToken)")
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
            kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    
    public func didFailToRegisterForRemoteNotificationsWithError(application: UIApplication, error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    
    public func didReceiveRemoteNotification(application: UIApplication, userInfo: [NSObject : AnyObject]) {
        GCMService.sharedInstance().appDidReceiveMessage(userInfo);
        onNotificationReceived(userInfo)
    }
    
    public func didReceiveRemoteNotification(application: UIApplication,
        userInfo: [NSObject : AnyObject],
        fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
            GCMService.sharedInstance().appDidReceiveMessage(userInfo)
            onNotificationReceived(userInfo)
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        onBackground = true
    }
    
    public func applicationDidBecomeActive(application: UIApplication) {
        onBackground = false
    }
}

