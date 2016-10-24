// MemoryNsCache.swift
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

import Foundation

class MemoryNsCache : Memory {
    fileprivate let records : NSCache<AnyObject, AnyObject>
    fileprivate var retainedKeys : Set<String>

    init() {
        records = NSCache()
        retainedKeys = Set<String>()
    }
    
    func getIfPresent<T>(_ key: String) -> Record<T>? {
        retainedKeys.insert(key)
        return records.object(forKey: key as AnyObject) as? Record<T>
    }
    func put<T>(_ key: String, record: Record<T>) {
        retainedKeys.insert(key)
        records.setObject(record, forKey: key as AnyObject)
    }
    
    func keys() -> [String] {
        return Array(retainedKeys)
    }
    
    func evict(_ key: String) {
        retainedKeys.remove(key)
        records.removeObject(forKey: key as AnyObject)
    }
    
    func evictAll() {
        retainedKeys.removeAll()
        records.removeAllObjects()
    }
}
