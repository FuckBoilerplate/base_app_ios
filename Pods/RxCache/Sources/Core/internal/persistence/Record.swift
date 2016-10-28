// Record.swift
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

class Record<T> : NSObject, NSCoding {
    var source : Source!
    var timeAtWhichWasPersisted : Double!
    var lifeTimeInSeconds: Double!
    var sizeOnMb : Double!
    var cacheables : [T]!
    private var JSONs = [JSON]()
    var isExpirable : Bool
    
    
    init(cacheables : [T], lifeTimeInSeconds: Double, isExpirable: Bool) {
        self.source = Source.Memory
        self.cacheables = cacheables
        self.timeAtWhichWasPersisted = NSDate().timeIntervalSince1970
        self.lifeTimeInSeconds = lifeTimeInSeconds
        self.isExpirable = isExpirable
    }
    
    //for testing purpose only
    init(source: Source, cacheables : [T], timeAtWhichWasPersisted: Double, lifeTimeInSeconds: Double) {
        self.source = source
        self.cacheables = cacheables
        self.timeAtWhichWasPersisted = timeAtWhichWasPersisted
        self.lifeTimeInSeconds = lifeTimeInSeconds
        self.isExpirable = true
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        source = Source(rawValue: aDecoder.decodeObject(forKey: "source") as! String)
        timeAtWhichWasPersisted = aDecoder.decodeObject(forKey: "timeAtWhichWasPersisted") as! Double
        lifeTimeInSeconds = aDecoder.decodeObject(forKey: "lifeTimeInSeconds") as! Double
        isExpirable = aDecoder.decodeBool(forKey: "isExpirable")
        
        JSONs = aDecoder.decodeObject(forKey: "JSONs") as! [[String: AnyObject]]
        cacheables = [T]()
        
        for JSON in JSONs {
            if let cacheable = T.self as? Cacheable.Type {
                let instance = cacheable.init(json:JSON)
                cacheables.append(instance as! T)
            } else {
                fatalError((String(describing: T.self) + Locale.CacheableIsNotEnought))
            }
        }
        
        JSONs.removeAll()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(source.rawValue, forKey: "source")
        aCoder.encode(timeAtWhichWasPersisted, forKey: "timeAtWhichWasPersisted")
        aCoder.encode(lifeTimeInSeconds, forKey: "lifeTimeInSeconds")
        aCoder.encode(isExpirable, forKey: "isExpirable")
        
        for cacheable in cacheables {
            if let cacheable = cacheable as? Cacheable {
                if let obj = cacheable.toJSON() {
                    JSONs.append(obj)
                }
            }
        }
        
        aCoder.encode(JSONs, forKey: "JSONs")
    }
}
