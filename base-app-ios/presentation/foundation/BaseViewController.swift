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

class BaseViewController<P: Presenter>: UIViewController {//, GcmReceiverUIForeground {
    
    var presenter: P!
    var syncScreens: SyncScreens!
    var wireframe: Wireframe!
    
    override func viewWillAppear(_ animated: Bool) {
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
    func showAlert(_ oTitle: Observable<String>) {
        oTitle.subscribe(onNext: { message in self.showAlertMessage(message) })
    }
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
    // MARK: - GcmReceiverUIForeground
//    func onTargetNotification(_ ignore: Observable<RxMessage>) {}
//    
//    func onMismatchTargetNotification(_ oMessage: Observable<RxMessage>) {
//        let oGcmNotification = oMessage
//            .map { message in GcmNotification<AnyObject>.getMessageFromGcmNotification(message) }
//            .map { gcmNotification in "\(gcmNotification.title) \n \(gcmNotification.body)" }
//        
//        showAlert(oGcmNotification)
//    }
//    
    func target() -> String {
        return ""
    }

}

extension UIViewController {
    
    func showAlertMessage(_ message: String) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Apply loading & safety report
extension ObservableType {
    
    /**
     * Handles observable schedulers.
     */
    func safely() -> Observable<E> {
        return self.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func safelyLoading<P>(_ viewController: BaseViewController<P>) -> Observable<E> {
        return safely().applyLoading(viewController)
    }
    
    /**
     * Handles observable subscriptions, not throw any exception and report it using feedback.
     */
    func safelyReport<P>(_ viewController: BaseViewController<P>?) -> Observable<E> {
        return safely()
            .do(onError: { error in viewController?.showAlert(Observable.just((error as NSError).domain)) })
    }
    
    func safelyReportLoading<P>(_ viewController: BaseViewController<P>) -> Observable<E> {
        return safelyReport(viewController).applyLoading(viewController)
    }
    
    func applyLoading<P>(_ viewController: BaseViewController<P>) -> Observable<E> {
        viewController.showLoading()
        return self.do(onCompleted: { _ in  viewController.hideLoading() })
    }
}
