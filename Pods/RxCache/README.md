[![Version](https://img.shields.io/cocoapods/v/RxCache.svg?style=flat)](http://cocoapods.org/pods/RxCache)
[![License](https://img.shields.io/cocoapods/l/RxCache.svg?style=flat)](http://cocoapods.org/pods/RxCache)
[![Platform](https://img.shields.io/cocoapods/p/RxCache.svg?style=flat)](http://cocoapods.org/pods/RxCache)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/VictorAlbertos/RxSCache.svg?branch=master)](https://travis-ci.org/VictorAlbertos/RxSCache)

RxCache
========

_Swift adaptation from the original [RxCache Java version](https://github.com/VictorAlbertos/RxCache)_.

The **goal** of this library is simple: **caching your data models like [SDWebImage](https://github.com/rs/SDWebImage) caches your images, with no effort at all.** 

Every Swift application is a client application, which means it does not make sense to create and maintain a database just for caching data.

Plus, the fact that you have some sort of legendary database for persisting your data does not solves by itself the real challenge: to be able to configure your caching needs in a flexible and simple way. 

Inspired by [Moya](https://github.com/Moya/Moya) api, **RxCache is a reactive caching library for Swift which relies on [RxSwift](https://github.com/ReactiveX/RxSwift) for turning your caching needs into an enum.** 

Every enum value acts as a provider for RxCache, and all of them are managed through observables; they are the fundamental contract 
between the library and its clients. 

When supplying an observable which contains the data provided by an expensive task -probably a http connection, RxCache determines if it is needed 
to subscribe to it or instead fetch the data previously cached. This decision is made based on the providers configuration.

So, when supplying an observable you get your observable cached back, and next time you will retrieve it without the time cost associated with its underlying task. 


Installation
============

RxCache is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxCache', '~> 0.1.1'
```

RxCache also is available using [Carthage](https://github.com/Carthage/Carthage). To install it add the following dependency to your `Cartfile`:

```
github "VictorAlbertos/RxSCache" ~> 0.1.1
```

Usage
=====

Prepare yor data model
----------------------
The data model which will be used for RxCache requires to conform with [GlossCacheable](https://github.com/VictorAlbertos/RxSCache/blob/master/Sources/GlossCacheable.swift) or [OMCacheable](https://github.com/VictorAlbertos/RxSCache/blob/master/Sources/OMCacheable.swift) protocol.

Create the enum providers 
-------------------------
After your model conforms with RxObject protocol, you can now create an enum which conforms with the Provider protocol with as much values as needed to create the caching providers:

```swift
enum CacheProviders : Provider {
    case GetMocks()
    case GetMocksWith5MinutesLifeTime()
    case GetMocksEvictProvider(evict : Bool)
    case GetMocksPaginate(page : Int)
    case GetMocksPaginateEvictingPerPage(page : Int, evictByPage: Bool)
    case GetMocksPaginateWithFiltersEvictingPerFilter(filter: String, page : String, evictByPage: Bool)

    var lifeCache: LifeCache? {
        switch self {
        case GetMocksWith5MinutesLifeTime:
            return LifeCache(duration: 5, timeUnit: LifeCache.TimeUnit.Minutes)
        default:
            return nil
        }
    }
    
    var dynamicKey: DynamicKey? {
        switch self {
        case let GetMocksPaginate(page):
            return DynamicKey(dynamicKey: String(page))
        case let GetMocksPaginateEvictingPerPage(page, _):
            return DynamicKey(dynamicKey: String(page))
        default:
            return nil
        }
    }
    
    var dynamicKeyGroup: DynamicKeyGroup? {
        switch self {
        case let GetMocksPaginateWithFiltersEvictingPerFilter(filter, page, _):
            return DynamicKeyGroup(dynamicKey: filter, group: page)
        default:
            return nil
        }
    }
    
    var evict: EvictProvider? {
        switch self {
        case let GetMocksEvictProvider(evict):
            return EvictProvider(evict: evict)
        case let GetMocksPaginateEvictingPerPage(_, evictByPage):
            return EvictDynamicKey(evict: evictByPage)
        case let GetMocksPaginateWithFiltersEvictingPerFilter(_, _, evictByPage):
            return EvictDynamicKey(evict: evictByPage)
        default:
            return nil
        }
    }

}
```


RxCache provides a set of classes to indicate how the Provider needs to handle the cached data:

* [LifeCache](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/LifeCache.swift) sets the amount of time before the data would be evicted. If LifeCache is not supplied, the data will be never evicted unless it is required explicitly using [EvictProvider](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictProvider.swift), [EvictDynamicKey](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictDynamicKey.swift) or [EvictDynamicKeyGroup](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictDynamicKeyGroup.swift).
* [EvictProvider](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictProvider.swift) allows to explicitly evict all the data associated with the provider. 
* [EvictDynamicKey](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictDynamicKey.swift) allows to explicitly evict the data of an specific [DynamicKey](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/DynamicKey.swift).
* [EvictDynamicKeyGroup](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/EvictDynamicKeyGroup.swift) allows to explicitly evict the data of an specific [DynamicKeyGroup](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/DynamicKeyGroup.swift).
* [DynamicKey](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/DynamicKey.swift) is a wrapper around the key object for those providers which need to handle multiple records, so they need to provide multiple keys, such us endpoints with pagination, ordering or filtering requirements. To evict the data associated with one particular key use EvictDynamicKey.  
* [DynamicKeyGroup](https://github.com/VictorAlbertos/RxSCache/blob/master/Pod/Classes/DynamicKeyGroup.swift) is a wrapper around the key and the group for those providers which need to handle multiple records grouped, so they need to provide multiple keys organized in groups, such us endpoints with filtering AND pagination requirements. To evict the data associated with the key of one particular group, use EvictDynamicKeyGroup. 


Using CacheProviders enum
-------------------------
Now you can use your enum providers calling RxCache.Providers.cache() static method.

It's a really good practice to organize your data providers in a set of Repository classes where RxCache and Moya work together. Indeed, RxCache is the perfect match for [Moya](https://github.com/Moya/Moya) to create a repository of auto-managed-caching data pointing to endpoints. 

This would be the MockRepository:

```swift
class MockRepository {
    private let providers: RxCache
    
    init() {
        providers = RxCache.Providers
    }
    
    func getMocks(update: Bool) -> Observable<[Mock]> {
        let provider : Provider = CacheProviders.GetMocksEvictProvider(evict: update)
        return providers.cache(getExpensiveMocks(), provider: provider)
    }
    
    func getMocksPaginate(page: Int, update: Bool) -> Observable<[Mock]> {
        let provider : Provider = CacheProviders.GetMocksPaginateEvictingPerPage(page: page, evictByPage: update)
        return providers.cache(getExpensiveMocks(), provider: provider)
    }
    
    func getMocksWithFiltersPaginate(filter: String, page: Int, update: Bool) -> Observable<[Mock]> {
        let provider : Provider = CacheProviders.GetMocksPaginateWithFiltersEvictingPerFilter(filter: filter, page: page, evictByPage: update)
        return providers.cache(getExpensiveMocks(), provider: provider)
    }
    
    //In a real use case, here is when you build your observable with the expensive operation.
    //Or if you are making http calls you can use Moya-RxSwift extensions to get it out of the box.
    private func getExpensiveMocks() -> Observable<[Mock]> {
        return Observable.just([Mock]())
    }
}
```


Use cases
=========
Following use cases illustrate some common scenarios which will help to understand the usage of DynamicKey and DynamicKeyGroup classes along with evicting scopes. 

Enum providers example
----------------------
```swift
enum CacheProviders : Provider {
    // Mock List
    case GetMocks() // Mock List without evicting
    case GetMocksEvictProvider(evictProvider : EvictProvider) // Mock List evicting
    
    // Mock List Filtering
    case GetMocksFiltered(filter: String) // Mock List filtering without evicting
    case GetMocksFilteredEvict(filter: String, evictProvider : EvictProvider) // Mock List filtering evicting
    
    // Mock List Paginated with filters
    case GetMocksFilteredPaginate(filterAndPage: String) // Mock List paginated with filters without evicting
    case GetMocksFilteredPaginateEvict(filter: String, page: Int, evictProvider : EvictProvider) // Mock List paginated with filters evicting

    var lifeCache: LifeCache? {
        return nil
    }
    
    var dynamicKey: DynamicKey? {
        switch self {
        case let GetMocksFiltered(filter):
            return DynamicKey(dynamicKey: filter)
        case let GetMocksFilteredEvict(filter, _):
            return DynamicKey(dynamicKey: filter)
        case let GetMocksFilteredPaginate(filterAndPage):
            return DynamicKey(dynamicKey: filterAndPage)
        default:
            return nil
        }
    }
    
    var dynamicKeyGroup: DynamicKeyGroup? {
        switch self {
        case let GetMocksFilteredPaginateEvict(filter, page, _):
            return DynamicKeyGroup(dynamicKey: filter, group: String(page))
        default:
            return nil
        }
    }
    
    var evict: EvictProvider? {
        switch self {
        case let GetMocksFilteredEvict(_, evictProvider):
            return evictProvider
        case let GetMocksFilteredPaginateEvict(_, _, evictProvider):
            return evictProvider
        default:
            return nil
        }
    }

}
```

Mock List
---------
```swift
//Hit observable evicting all mocks 
let provider : Provider = CacheProviders.GetMocksEvictProvider(evictProvider: EvictProvider(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)

//This lines return an error observable: "EvictDynamicKey was provided but not was provided any DynamicKey"
let provider : Provider = CacheProviders.GetMocksEvictProvider(evictProvider: EvictDynamicKey(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)
```

Mock List Filtering
-------------------
```swift
//Hit observable evicting all mocks using EvictProvider
let provider : Provider = CacheProviders.GetMocksFilteredEvict(filter: "actives", evictProvider: EvictProvider(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)

//Hit observable evicting mocks of one filter using EvictDynamicKey
let provider : Provider = CacheProviders.GetMocksFilteredEvict(filter: "actives", evictProvider: EvictDynamicKey(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)

//This lines return an error observable: "EvictDynamicKeyGroup was provided but not was provided any Group"
let provider : Provider = CacheProviders.GetMocksFilteredEvict(filter: "actives", evictProvider: EvictDynamicKeyGroup(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)
```		
		
Mock List Paginated with filters
--------------------------------
```swift
//Hit observable evicting all mocks using EvictProvider
let provider : Provider = CacheProviders.GetMocksFilteredPaginateEvict(filter: "actives", page: 1, evictProvider: EvictProvider(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)

//Hit observable evicting all mocks pages of one filter using EvictDynamicKey
let provider : Provider = CacheProviders.GetMocksFilteredPaginateEvict(filter: "actives", page: 1, evictProvider: EvictDynamicKey(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)

//Hit observable evicting one page mocks of one filter using EvictDynamicKeyGroup
let provider : Provider = CacheProviders.GetMocksFilteredPaginateEvict(filter: "actives", page: 1, evictProvider: EvictDynamicKeyGroup(evict: true))
providers.cache(getExpensiveMocks(), provider: provider)
```		

As you may already notice, the whole point of using DynamicKey or DynamicKeyGroup along with Evict classes is to play with several scopes when evicting objects.

The enum provider example declare type which their associated value accepts EvictProvider in order to be able to concrete more specifics types of EvictProvider at runtime.

But I have done that for demonstration purposes, you always should narrow the evicting classes to the type which you really need -indeed, you should not expose the Evict classes as an associated value, instead require a Bool and hide the implementation detail in your enum provider. 

For the last example, Mock List Paginated with filters, I would narrow the scope to EvictDynamicKey in production code, because this way I would be able to paginate the filtered mocks and evict them per its filter, triggered by a pull to refresh for instance.


Configure general behaviour
===========================

Configure the limit in megabytes for the data to be persisted 
-------------------------------------------------------------
By default, RxCache sets the limit in 300 megabytes, but you can change this value by calling maxMBPersistenceCache property in RxCache.Providers single instance:

```swift
RxCache.Providers.maxMBPersistenceCache = 100
```

This limit ensure that the disk will no grow up limitless in case you have providers with dynamic keys which values changes dynamically, like filters based on gps location or dynamic filters supplied by your back-end solution.

When this limit is reached, RxCache will not be able to persisted in disk new data. That's why RxCache has an automated process which allows to evict 'expirable' records. And by 'expirable' I mean any object which has been saved using a provider whose LifeCache wouldn't be nil.

So any record persisted with LifeCache is a candidate to be evicted when new data is requested but there is no more available disk space, even it its life time has not been fulfilled.

Use expired data if loader not available
----------------------------------------
By default, RxCache will return an observable error if the cached data has expired and the data returned by the observable loader is null, 
preventing this way serving data which has been marked as evicted.

You can modify this behaviour, allowing RxCache serving evicted data when the loader has returned nil values, by setting as true the value of useExpiredDataIfLoaderNotAvailable

```swift
RxCache.Providers.useExpiredDataIfLoaderNotAvailable = true
```


Internals
=========
RxCache serves the data from one of its three layers:

* A memory layer -> Powered by [NSCache](https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Reference/NSCache_Class/index.html).
* A persisting layer -> RxCache uses internally [NSCoding](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSCoding_Protocol/) for serialize and deserialize the JSON resulting from conforming with the RxObject protocol.
* A loader layer (the observable supplied by the client library)

The policy is very simple: 

* If the data requested is in memory, and It has not been expired, get it from memory.
* Else if the data requested is in persistence layer, and It has not been expired, get it from persistence.
* Else get it from the loader layer. 

Author
======
**Víctor Albertos**

* <https://twitter.com/_victorAlbertos>
* <https://linkedin.com/in/victoralbertos>
* <https://github.com/VictorAlbertos>

RxCache Android version:
========================
* [RxCache](https://github.com/VictorAlbertos/RxCache): Reactive caching library for Android and Java.

License
=======

RxCache is available under the MIT license. See the LICENSE file for more info.
