// Locale.swift
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

struct Locale {
    static let RxSDomain = "io.rxcache"
    static let NotDataReturnWhenCallingObservableLoader = "The Loader provided did not return any data and there is not data to load from the Cache"
    static let EvictDynamicKeyProvidedButNotProvidedAnyDynamicKey = " EvictDynamicKey was provided but not was provided any DynamicKey"
    static let EvictDynamicKeyGroupProvidedButNotProvidedAnyDynamicKeyGroup = " EvictDynamicKeyGroup was provided but not was provided any Group"
    static let DataCanNotBePersistedBecauseWouldExceedThresholdLimit = "RxCache -> Data can not be persisted because it would exceed the max limit megabytes settled down"
    static let RecordCanNotBeEvictedBecauseNoOneIsExpirable = "Records can not be evicted because no one is expirable";
    static let CacheableIsNotEnought = " needs to implements GlossCacheable or OMCacheable";
}
