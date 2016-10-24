//
//  RxCacheProviders.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/4/16.
//  Copyright © 2016 jaime. All rights reserved.
//

import RxCache

enum RxCacheProviders {
    case getUsers(evict : Bool)
    case getWireframeCurrentObject(evict: Bool)
}

extension RxCacheProviders: Provider {
    
    var lifeCache: LifeCache? {
        switch self {
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
        case let .getUsers(evict): return EvictProvider(evict: evict)
        case let .getWireframeCurrentObject(evict): return EvictProvider(evict: evict)
        default:
            return nil
        }
    }
}
