//
//  WireframeRepository.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import RxCache

class WireframeRepository: Repository {

    override init(restApi: RestApi, rxProviders: RxCache) {
        super.init(restApi: restApi, rxProviders: rxProviders)
    }
    
    func getWireframeCurrentObject<T>() -> Observable<T> {
        let provider = RxCacheProviders.getWireframeCurrentObject(evict: false)
        return rxProviders.cache(RxCache.errorObservable(T), provider: provider)
    }
    
    func setWireframeCurrentObject<T>(_ object: T) -> Observable<Void> {
        let provider = RxCacheProviders.getWireframeCurrentObject(evict: true)
        return rxProviders.cache(Observable.just(object), provider: provider)
            .map { _ in }
    }
}
