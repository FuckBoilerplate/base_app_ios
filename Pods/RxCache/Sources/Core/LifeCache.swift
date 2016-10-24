// LifeTime.swift
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

/**
* If set, it determines the period of time during which the associated cache will be exists.
* If not set, the cache will not be evicted, as long as it has not been explicitly required
* using an Evict class
* see EvictProvider
*/
open class LifeCache : NSObject {
    let duration : Double
    let timeUnit : TimeUnit

    public init(duration : Double, timeUnit : TimeUnit) {
        self.duration = duration
        self.timeUnit = timeUnit
    }
    
    public enum TimeUnit : Int {
        case seconds = 1
        case minutes = 60
        case hours = 3600
        case days = 86400
    }
    
    internal func getLifeTimeInSeconds() -> Double {
        return duration * Double(timeUnit.rawValue)
    }
}
