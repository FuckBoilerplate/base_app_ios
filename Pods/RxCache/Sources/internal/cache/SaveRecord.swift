// SaveRecord.swift
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

class SaveRecord : Action {
    let memory : Memory
    let evictExpirableRecordsPersistence : EvictExpirableRecordsPersistence
    private let persistence : Persistence

    init(memory : Memory, persistence : Persistence) {
        self.memory = memory
        self.evictExpirableRecordsPersistence = EvictExpirableRecordsPersistence(persistence: persistence)
        self.persistence = persistence
    }
    
    func save<T>(providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?, cacheables: [T], lifeCache: LifeCache?, maxMBPersistenceCache: Int) {
        let composedKey = composeKey(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup);
        
        let lifeTimeInSeconds = lifeCache != nil ? lifeCache!.getLifeTimeInSeconds() : 0
        let record : Record<T> = Record(cacheables: cacheables, lifeTimeInSeconds: lifeTimeInSeconds)
        memory.put(composedKey, record: record)
        
        if let storedMB = persistence.storedMB() where storedMB >= maxMBPersistenceCache {
            print(Locale.DataCanNotBePersistedBecauseWouldExceedThresholdLimit)
        } else {
            persistence.saveRecord(composedKey, record: record)
        }
        
        evictExpirableRecordsPersistence.maxMgPersistenceCache = maxMBPersistenceCache
        evictExpirableRecordsPersistence.startTaskIfNeeded()
    }
    
}