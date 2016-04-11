//
//  RxCacheProviders.swift
//  app_pesca_ios
//
//  Created by Roberto Frontado on 2/4/16.
//  Copyright © 2016 jaime. All rights reserved.
//

import RxCache

enum RxCacheProviders {
    case GetSelectedUserDemoList(evict : Bool)
    case GetWireframeCurrentObject(evict: Bool)
}

extension RxCacheProviders: Provider {
    
    var lifeCache: LifeCache? {
        switch self {
        case  GetSelectedUserDemoList: return LifeCache(duration: 5, timeUnit: LifeCache.TimeUnit.Hours)
        default:
            return nil
        }
    }
    
    var dynamicKey: DynamicKey? {
        switch self {
        default:
            return nil
        }
    }
    
    var dynamicKeyGroup: DynamicKeyGroup? {
        switch self {
        default: return nil
        }
    }
    
    var evict: EvictProvider? {
        switch self {
        case let GetSelectedUserDemoList(evict): return EvictProvider(evict: evict)
        case let GetWireframeCurrentObject(evict): return EvictProvider(evict: evict)
        default:
            return nil
        }
    }
}