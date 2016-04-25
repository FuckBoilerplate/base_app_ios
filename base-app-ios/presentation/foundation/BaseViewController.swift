//
//  BaseViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class BaseViewController<P: Presenter>: UIViewController, GcmReceiverUIForeground {
    
    var presenter: P!
    var syncScreens: SyncScreens!
    var wireframe: Wireframe!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if syncScreens.needToSync(target()) {
            onSyncScreen()
        }
    }

    func back() {
        wireframe.popCurrentScreen()
    }

    /**
    * Override this method and do not call super to add functionality when sync screen is called
    */
    func onSyncScreen() {
        fatalError("onSyncScreen was call for class %1$s but subclass does not override this method")
    }
    
    // MARK: - BaseView
    func showAlert(oTitle: Observable<String>) {
        oTitle.subscribeNext { message in self.showAlertMessage(message) }
    }
    
    func showLoading() {
        HUD.show(.Progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    // MARK: - GcmReceiverUIForeground
    func onTargetNotification(ignore: Observable<RxMessage>) {}
    
    func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
        let oGcmNotification = oMessage
            .map { message in GcmNotification<AnyObject>.getMessageFromGcmNotification(message) }
            .map { gcmNotification in "\(gcmNotification.title) \n \(gcmNotification.body)" }
        
        showAlert(oGcmNotification)
    }
    
    func target() -> String {
        return ""
    }

}

extension UIViewController {
    
    func showAlertMessage(message: String) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - Apply loading & safety report
extension ObservableType {
    
    /**
     * Handles observable schedulers.
     */
    func safely() -> Observable<E> {
        return self.subscribeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .observeOn(MainScheduler.instance)
    }
    
    func safelyLoading<P>(viewController: BaseViewController<P>) -> Observable<E> {
        return safely().applyLoading(viewController)
    }
    
    /**
     * Handles observable subscriptions, not throw any exception and report it using feedback.
     */
    func safelyReport<P>(viewController: BaseViewController<P>?) -> Observable<E> {
        return safely().doOn(onError: { error in viewController?.showAlert(Observable.just((error as NSError).domain)) })
    }
    
    func safelyReportLoading<P>(viewController: BaseViewController<P>) -> Observable<E> {
        return safelyReport(viewController).applyLoading(viewController)
    }
    
    func applyLoading<P>(viewController: BaseViewController<P>) -> Observable<E> {
        viewController.showLoading()
        return doOn(onCompleted: { _ in  viewController.hideLoading() })
    }
}
