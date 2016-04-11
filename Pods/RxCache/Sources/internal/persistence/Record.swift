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
    
    init(cacheables : [T], lifeTimeInSeconds: Double) {
        self.source = Source.Memory
        self.cacheables = cacheables
        self.timeAtWhichWasPersisted = NSDate().timeIntervalSince1970
        self.lifeTimeInSeconds = lifeTimeInSeconds
    }
    
    //for testing purpose only
    init(source: Source, cacheables : [T], timeAtWhichWasPersisted: Double, lifeTimeInSeconds: Double) {
        self.source = source
        self.cacheables = cacheables
        self.timeAtWhichWasPersisted = timeAtWhichWasPersisted
        self.lifeTimeInSeconds = lifeTimeInSeconds
    }
    
    @objc required init(coder aDecoder: NSCoder) {
        source = Source(rawValue: aDecoder.decodeObjectForKey("source") as! String)
        timeAtWhichWasPersisted = aDecoder.decodeObjectForKey("timeAtWhichWasPersisted") as! Double
        lifeTimeInSeconds = aDecoder.decodeObjectForKey("lifeTimeInSeconds") as! Double
        JSONs = aDecoder.decodeObjectForKey("JSONs") as! [[String: AnyObject]]
        cacheables = [T]()
        
        for JSON in JSONs {
            if let gloss = T.self as? GlossCacheable.Type {
                let instance = gloss.init(json:JSON)
                cacheables.append(instance as! T)
            } else if let mapper = T.self as? OMCacheable.Type {
                let instance = mapper.init(JSON:JSON)
                cacheables.append(instance as! T)
            } else {
                fatalError((String(T.self) + Locale.CacheableIsNotEnought))
            }
        }
        
        JSONs.removeAll()
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(source.rawValue, forKey: "source")
        aCoder.encodeObject(timeAtWhichWasPersisted, forKey: "timeAtWhichWasPersisted")
        aCoder.encodeObject(lifeTimeInSeconds, forKey: "lifeTimeInSeconds")
        
        for cacheable in cacheables {
            if let gloss = cacheable as? GlossCacheable {
                JSONs.append(gloss.toJSON()!)
            } else if let mapper = cacheable as? OMCacheable {
                JSONs.append(mapper.toJSON())
            } else {
                fatalError((String(T.self) + Locale.CacheableIsNotEnought))
            }
        }
        
        aCoder.encodeObject(JSONs, forKey: "JSONs")
    }
}
