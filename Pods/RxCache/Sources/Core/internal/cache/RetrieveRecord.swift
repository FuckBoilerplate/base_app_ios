// RetrievedRecord.swift
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

class RetrieveRecord : Action {
    let memory : Memory
    fileprivate let evictRecord : EvictRecord
    fileprivate let hasRecordExpired : HasRecordExpired
    fileprivate let persistence : Persistence
    
    init(memory : Memory, evictRecord : EvictRecord, hasRecordExpired : HasRecordExpired, persistence : Persistence) {
        self.memory = memory
        self.evictRecord = evictRecord
        self.hasRecordExpired = hasRecordExpired
        self.persistence = persistence
    }
    
    func retrieve<T>(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?, useExpiredDataIfLoaderNotAvailable: Bool, lifeCache: LifeCache?) -> Record<T>? {

        let composedKey = composeKey(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup);

        
        var record : Record<T>
        if let recordMemory : Record<T> = memory.getIfPresent(composedKey) {
            record = recordMemory
            record.source = Source.Memory
        } else if let recordPersistence: Record<T> = persistence.retrieveRecord(composedKey) {
            record = recordPersistence
            record.source = Source.Persistence
            memory.put(composedKey, record: record)
        } else {
            return nil
        }
        
        let lifeTimeInSeconds = lifeCache != nil ? lifeCache!.getLifeTimeInSeconds() : 0
        record.lifeTimeInSeconds = lifeTimeInSeconds
        
        if hasRecordExpired.hasRecordExpired(record: record) {
            if let dynamicKeyGroup = dynamicKeyGroup {
                evictRecord.evictRecordMatchingDynamicKeyGroup(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup)
            } else if let dynamicKey = dynamicKey {
                evictRecord.evictRecordsMatchingDynamicKey(providerKey, dynamicKey: dynamicKey)
            } else {
                evictRecord.evictRecordsMatchingProviderKey(providerKey)
            }
            
            return useExpiredDataIfLoaderNotAvailable ? record : nil
        }
        
        return record
    }
}
