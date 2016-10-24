 // ProvidersExtensions.swift
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

extension RxCache {
    
    func cacheArray<T>(_ observable : Observable<[T]>, provider : Provider) -> Observable<Reply<[T]>> {
        return Observable.deferred {
            if let configError : Observable<Reply<[T]>> = self.checkIntegrityConfiguration(provider) {
                return configError
            }
        
            let record : Record<T>? = self.twoLayersCache.retrieve(provider.providerKey, dynamicKey: provider.dynamicKey, dynamicKeyGroup: provider.dynamicKeyGroup, useExpiredDataIfLoaderNotAvailable: self.useExpiredDataIfLoaderNotAvailable, lifeCache: provider.lifeCache)
            
            return Observable.just(record)
                .map({ (record) -> Observable<Reply<[T]>> in
                if let record = record , provider.evict == nil || provider.evict?.evict == false {
                    return Observable.just(Reply(source: record.source, cacheables: record.cacheables));
                }
                return self.getDataFromLoader(observable, provider: provider, record: record)
            }).flatMap { (oReply) -> Observable<Reply<[T]>> in
                return oReply.map({ (reply) -> Reply<[T]> in
                    let cacheablesDeepCopy = self.getDeepCopy.getDeepCopy(objects: reply.cacheables)
                    return Reply(source: reply.source, cacheables: cacheablesDeepCopy)
                })
            }
        }
    }
    
    fileprivate func getDataFromLoader<T>(_ observableLoader : Observable<[T]>, provider : Provider, record : Record<T>?) -> Observable<Reply<[T]>> {
        return observableLoader
            .map { (cacheables) -> Reply<[T]> in
            
                self.clearKeyIfNeeded(provider)
                
                
                self.twoLayersCache.save(provider.providerKey, dynamicKey: provider.dynamicKey, dynamicKeyGroup: provider.dynamicKeyGroup, cacheables: cacheables, lifeCache: provider.lifeCache, maxMBPersistenceCache : self.maxMBPersistenceCache, isExpirable: provider.expirable())
                return Reply(source: Source.Cloud, cacheables: cacheables)
            
            }.catchError({ (errorType) -> Observable<Reply<[T]>> in
                self.clearKeyIfNeeded(provider)
                
                if (record != nil && self.useExpiredDataIfLoaderNotAvailable) {
                    return Observable.just(Reply(source: record!.source, cacheables: record!.cacheables))
                }
                
                return Observable.error(NSError(domain: Locale.NotDataReturnWhenCallingObservableLoader + " " + provider.providerKey, code: 0, userInfo: nil))
            })
    }
    
    fileprivate func checkIntegrityConfiguration<T>(_ provider : Provider) -> Observable<Reply<[T]>>? {
        if let evict = provider.evict {
            if evict is EvictDynamicKeyGroup {
                if provider.dynamicKeyGroup == nil {
                    return Observable.error(NSError(domain: provider.providerKey + " " + Locale.EvictDynamicKeyGroupProvidedButNotProvidedAnyDynamicKeyGroup, code: 0, userInfo: nil))
                }
            } else if evict is EvictDynamicKey {
                if provider.dynamicKey == nil && provider.dynamicKeyGroup == nil {
                    return Observable.error(NSError(domain: provider.providerKey + " " + Locale.EvictDynamicKeyProvidedButNotProvidedAnyDynamicKey, code: 0, userInfo: nil))
                }
            }
        }
        
        return nil
    }
    
    fileprivate func clearKeyIfNeeded(_ provider : Provider) {
        let providerKey = provider.providerKey
        var dynamicKey = provider.dynamicKey
        let dynamicKeyGroup = provider.dynamicKeyGroup
        
        if let evict = provider.evict {
            if !evict.evict {
                return
            }
            
            if evict is EvictDynamicKeyGroup  {
                self.twoLayersCache.evictDynamicKeyGroup(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup)
            } else if evict is EvictDynamicKey {
                if dynamicKey == nil {
                    dynamicKey = DynamicKey(dynamicKey: (provider.dynamicKeyGroup?.dynamicKey)!)
                }
                self.twoLayersCache.evictDynamicKey(providerKey, dynamicKey: dynamicKey)
            } else {
                self.twoLayersCache.evictProviderKey(providerKey)
            }
        }
    }
}
