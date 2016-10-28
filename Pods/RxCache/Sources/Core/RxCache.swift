// Providers.swift
// RxCache
//
// Copyright (c) 2016 Victor Albertos https://github.com/VictorAlbertos
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import RxSwift


open class RxCache {
    /**
     The one and only instance of RxCache class
     */
    open static let Providers = RxCache()
    
    /**
     * If true RxCache will serve Records already expired, instead of evict them and throw an exception
     * If not supplied, false will be the default option
     */
    open var useExpiredDataIfLoaderNotAvailable : Bool
    
    
    /**
     * Sets the max memory in megabytes for all stored records on persistence layer
     * If not supplied, 100 megabytes will be the default option
     */
    open var maxMBPersistenceCache : Int

    let twoLayersCache : TwoLayersCache
    let evictExpiredRecordsPersistence: EvictExpiredRecordsPersistence
    let getDeepCopy: GetDeepCopy
    
    fileprivate init() {
        useExpiredDataIfLoaderNotAvailable = false
        maxMBPersistenceCache = 300
        
        let persistence = Disk()
        
        getDeepCopy = GetDeepCopy()
        
        twoLayersCache = TwoLayersCache(persistence: persistence)
        
        evictExpiredRecordsPersistence = EvictExpiredRecordsPersistence(persistence: persistence)
    
        //let scheduler : ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS.Background)
        
        evictExpiredRecordsPersistence.startEvictingExpiredRecords()
            //.subscribeOn(scheduler)
            .subscribe()
            .addDisposableTo(DisposeBag())
    }
    
    open func cacheWithReply<T>(_ observable : Observable<T>,  provider : Provider) -> Observable<Reply<T>> {
        return self.cacheArray(observable.toArray(), provider: provider).flatMap({ (reply) -> Observable<Reply<T>> in
            return Observable.just(Reply(source: reply.source, cacheables: reply.cacheables[0]))
        })
    }
    
    open func cacheWithReply<T>(_ observable : Observable<[T]>,  provider : Provider) -> Observable<Reply<[T]>> {
        return self.cacheArray(observable, provider: provider)
    }
    
    open func cache<T>(_ observable : Observable<[T]>,  provider : Provider) -> Observable<[T]> {
        return self.cacheArray(observable, provider: provider)
            .flatMap({ (reply) -> Observable<[T]> in
                return Observable.just(reply.cacheables)
            })
    }
    
    open func cache<T>(_ observable : Observable<T>,  provider : Provider) -> Observable<T> {
        return self.cacheArray(observable.toArray(), provider: provider)
            .flatMap({ (reply) -> Observable<T> in
                return Observable.just(reply.cacheables[0])
            })
    }
    
    open func evictAll() -> Observable<Void> {
        return Observable.deferred({ () -> Observable<Void> in
            self.twoLayersCache.evictAll()
            return Observable.empty()
        })
    }
    
    open class func errorObservable<T>(_ t : T.Type)-> Observable<T> {
        return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
    }
}
