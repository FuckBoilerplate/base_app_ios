//
//  Presenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**
 Base class for any Presenter.
 The presenter is responsible for linking the uses cases in order to create a logical unit
 which will be represented as a screen in the application.
 
 - Parameters:
    - V: The view interface attached to this presenter.
        - See: [BaseView.swift](BaseView.swift)
    - W: The wireframe interface attached to this presenter.
        - See: [Wireframe.swift](Wireframe.swift)
 
 */

class Presenter {
    
    internal var view: BaseView?
    internal let wireframe: Wireframe
    internal let notificationRepository: NotificationRepository
    private let subscriptions: CompositeDisposable

    
    init(wireframe: Wireframe, notificationRepository: NotificationRepository) {
        self.wireframe = wireframe
        self.notificationRepository = notificationRepository
        self.subscriptions = CompositeDisposable()
    }
    
    /**
    * Called when view is required to initialize. On the iOS lifecycle ecosystem, it would be viewDidLoad.
    */
    func attachView(view: BaseView) {
        self.view = view
    }
    
    /**
    * Called when view is required to resume. On the iOS lifecycle ecosystem, it would be viewWillAppear.
    */
    func resumeView() {}
    
    /**
     * Handles observable subscriptions and not throw any exception.
     */
    func safety<T>(observable: Observable<T>) -> Disposing<T> {
        let configured = schedulers(observable).catchError { error in Observable.empty() }
        
        return Disposing(observable: configured, subscriptions: subscriptions)
    }
    
    /**
     * Handles observable subscriptions, not throw any exception and report it using feedback.
     */
    func safetyReportError<T>(observable: Observable<T>) -> Disposing<T> {
        let configured = schedulers(observable).catchError({ (error) -> Observable<T> in
//            self.uiDomain.showFeedback(Observable.just((error as NSError).domain))
            return Observable.empty()
        })
        
        return Disposing(observable: configured, subscriptions: subscriptions)
    }

    /**
     * Handles observable schedulers.
     */
    private func schedulers<T>(observable: Observable<T>) -> Observable<T> {
        return observable.subscribeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
    }
    
    func dispose() {
        if !subscriptions.disposed {
            subscriptions.dispose()
        }
    }
}
