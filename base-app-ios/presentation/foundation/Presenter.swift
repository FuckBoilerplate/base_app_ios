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
    
    init(wireframe: Wireframe) {
        self.wireframe = wireframe
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
    
    // GcmReceiverUIForeground
    func onTargetNotification(ignore: Observable<RxMessage>) {}
    
    func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
        let oGcmNotification = oMessage
            .map { message in GcmNotification<AnyObject>.getMessageFromGcmNotification(message) }
            .map { gcmNotification in "\(gcmNotification.title) \n \(gcmNotification.body)" }
        
        view?.showAlert(oGcmNotification)
    }
    
    func target() -> String {
        return ""
    }
    
}

// MARK: - Apply loading & safety report
extension ObservableType {
    
    /**
     * Handles observable subscriptions and not throw any exception.
     */
    func safety() -> Observable<E> {
        return self.applyLoading().catchError { error in Observable.empty() }
    }
    
    /**
     * Handles observable subscriptions, not throw any exception and report it using feedback.
     */
    func safetyReportError(view: BaseView?) -> Observable<E> {
        return self.applyLoading().catchError { error in
            view?.showAlert(Observable.just((error as NSError).domain))
            return Observable.empty()
        }
    }
    
    /**
     * Handles observable schedulers.
     */
    
    func applyLoading() -> Observable<E> {
        return self.subscribeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
    }
}
