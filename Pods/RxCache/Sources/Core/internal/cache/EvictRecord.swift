// EvictRecord.swift
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

class EvictRecord : Action {
    let memory : Memory
    fileprivate let persistence : Persistence

    init(memory : Memory, persistence : Persistence) {
        self.memory = memory
        self.persistence = persistence

    }
    
    func evictRecordsMatchingProviderKey(_ providerKey: String) {
        let keysMatchingKeyProvider = getKeysMatchingProviderKey(providerKey)
        
        keysMatchingKeyProvider.forEach { (keyMatchingKeyProvider) -> () in
            memory.evict(keyMatchingKeyProvider)
            persistence.evict(keyMatchingKeyProvider)
        }
    }
    
    func evictRecordsMatchingDynamicKey(_ providerKey: String, dynamicKey : DynamicKey?) {
        let keysMatchingDynamicKey = getKeysMatchingDynamicKey(providerKey, dynamicKey: dynamicKey)
        
        keysMatchingDynamicKey.forEach { (keyMatchingDynamicKey) -> () in
            memory.evict(keyMatchingDynamicKey)
            persistence.evict(keyMatchingDynamicKey)
        }
    }
    
    func evictRecordMatchingDynamicKeyGroup(_ providerKey: String, dynamicKey : DynamicKey?, dynamicKeyGroup : DynamicKeyGroup?) {
        let composedKey = getKeyMatchingDynamicKeyGroup(providerKey, dynamicKey: dynamicKey, dynamicKeyGroup: dynamicKeyGroup)
        memory.evict(composedKey)
        persistence.evict(composedKey)
    }
    
    func evictAll() {
        memory.evictAll()
        persistence.evictAll()
    }
    
    func mockMemoryDestroyed() {
        memory.evictAll()
    }
}
