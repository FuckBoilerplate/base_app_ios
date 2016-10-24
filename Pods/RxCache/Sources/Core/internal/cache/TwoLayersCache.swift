// TwoLayersCache.swift
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

class TwoLayersCache {
    var retrieveHasBeenCalled = false //testing purpourses
    private let evictRecord : EvictRecord;
    private let retrieveRecord : RetrieveRecord
    private let saveRecord : SaveRecord
    private let hasRecordExpired: HasRecordExpired
    
    init(persistence: Persistence) {
        let memory = MemoryNsCache()

        hasRecordExpired = HasRecordExpired()
        evictRecord = EvictRecord(memory: memory, persistence: persistence)
        retrieveRecord = RetrieveRecord(memory: memory, evictRecord: evictRecord, hasRecordExpired: hasRecordExpired, persistence: persistence)
        saveRecord = SaveRecord(memory: memory, persistence: persistence)
    }

    func retrieve<T>(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?, useExpiredDataIfLoaderNotAvailable: Bool, lifeCache: LifeCache?) -> Record<T>? {
        retrieveHasBeenCalled = true
        
        return retrieveRecord.retrieve(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup, useExpiredDataIfLoaderNotAvailable: useExpiredDataIfLoaderNotAvailable, lifeCache: lifeCache)
    }
    
    func save<T>(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?, cacheables: [T], lifeCache: LifeCache?, maxMBPersistenceCache: Int, isExpirable: Bool) {
        saveRecord.save(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup, cacheables: cacheables, lifeCache: lifeCache, maxMBPersistenceCache: maxMBPersistenceCache, isExpirable: isExpirable)
    }

    func evictProviderKey(_ providerKey : String) {
        evictRecord.evictRecordsMatchingProviderKey(providerKey)
    }
    
    func evictDynamicKey(_ providerKey: String, dynamicKey : DynamicKey?) {
        evictRecord.evictRecordsMatchingDynamicKey(providerKey, dynamicKey: dynamicKey)
    }
    
    func evictDynamicKeyGroup(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?) {
        evictRecord.evictRecordMatchingDynamicKeyGroup(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup : dynamicKeyGroup)
    }
    
    func evictAll() {
        evictRecord.evictAll()
    }
    
    func mockMemoryDestroyed() {
        evictRecord.mockMemoryDestroyed()
    }
}

