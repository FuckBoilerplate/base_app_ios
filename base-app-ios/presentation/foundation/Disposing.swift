//
//  Disposing.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/10/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**
 * Wrapper to hold a reference to the observable and the expected subscription.
 */
class Disposing<T> {
    var observable: Observable<T>
    private let subscriptions: CompositeDisposable
    
    init(observable: Observable<T>, subscriptions: CompositeDisposable) {
        self.observable = observable;
        self.subscriptions = subscriptions;
    }
    
    func disposable(subscription: (observable: Observable<T>) -> Disposable) {
        subscriptions.addDisposable(subscription(observable: observable))
    }
}
