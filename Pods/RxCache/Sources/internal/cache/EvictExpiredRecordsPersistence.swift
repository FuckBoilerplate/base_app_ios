// EvictExpiredRecordsPersistenceTask.swift
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

class EvictExpiredRecordsPersistence {
    private let hasRecordExpired: HasRecordExpired
    private let persistence : Persistence
    
    init (persistence : Persistence) {
        self.hasRecordExpired = HasRecordExpired()
        self.persistence = persistence
    }
    
    func startEvictingExpiredRecords() -> Observable<String> {        
        return Observable.create { subscriber in
            
            let allKeys = self.persistence.allKeys()
            allKeys.forEach({ (key) -> () in                
                if let record : Record<CacheablePlaceholder> = self.persistence.retrieveRecord(key) where self.hasRecordExpired.hasRecordExpired(record) {
                    self.persistence.evict(key)
                    subscriber.onNext(key)
                }
            })
    
            subscriber.onCompleted()
            return NopDisposable.instance
        }
    }
}

class CacheablePlaceholder : GlossCacheable {
    func toJSON() -> JSON? {
        return [String : AnyObject]()
    }
    
    required init(json: JSON) { }
}