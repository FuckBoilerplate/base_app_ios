// EvictExpirableRecordsPersistence.swift
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

class EvictExpirableRecordsPersistence {
    
    private static let PercentageMemoryStoredToStart = 0.95
    static let PercentageMemoryStoredToStop = 0.7 //visible for testing

    private let persistence : Persistence
    var maxMgPersistenceCache : Int!
    var couldBeExpirableRecords : Bool
    var isRunning : Bool
    
    init (persistence : Persistence) {
        self.persistence = persistence
        self.couldBeExpirableRecords = true
        self.isRunning = false
    }
    
    func startTaskIfNeeded() {
        DispatchQueue.global(qos: .default).async {
            if self.isRunning {
                return
            }
            
            self.isRunning = true
            
            if !self.couldBeExpirableRecords {
                self.isRunning  = false
                return
            }
            
            let storedMB = self.persistence.storedMB()
            
            if storedMB == nil {
                self.isRunning  = false
                return
            }
            
            if !self.reachedPercentageMemoryToStart(storedMB: storedMB!) {
                self.isRunning  = false
                return
            }
            
            let allKeys = self.persistence.allKeys()
            
            var releasedMBSoFar : Double = 0
            
            for key in allKeys  {
                if self.reachedPercentageMemoryToStop(storedMBWhenStarted: storedMB!, releasedMBSoFar: releasedMBSoFar) {
                    break
                }
                
                if let record : Record<CacheablePlaceholder> = self.persistence.retrieveRecord(key) {
                    if record.isExpirable && record.sizeOnMb != nil {
                        self.persistence.evict(key);
                        releasedMBSoFar += record.sizeOnMb
                    }
                }
            }
            
            self.couldBeExpirableRecords = self.reachedPercentageMemoryToStop(storedMBWhenStarted: storedMB!, releasedMBSoFar: releasedMBSoFar)
            
            self.isRunning  = false
        }
    }
    
    private func reachedPercentageMemoryToStop(storedMBWhenStarted: Int, releasedMBSoFar: Double) -> Bool {
        let currentStoredMB = Double(storedMBWhenStarted) - releasedMBSoFar;
        let requiredStoredMBToStop = Double(maxMgPersistenceCache) * EvictExpirableRecordsPersistence.PercentageMemoryStoredToStop;
        return currentStoredMB <= requiredStoredMBToStop;
    }
    
    private func reachedPercentageMemoryToStart(storedMB: Int) -> Bool {
        let requiredStoredMBToStart = Int(Double(maxMgPersistenceCache) * EvictExpirableRecordsPersistence.PercentageMemoryStoredToStart)
        return storedMB >= requiredStoredMBToStart
    }
}
