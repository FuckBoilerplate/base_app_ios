//
//  Observable+ObserveOnBackgroundThread.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/14/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

extension Observable {
    
    func observeOnBackgroundThread() -> Observable<E> {
        return self.observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
    }
}