//
//  PlaceholderProvider.swift
//  RxCache
//
//  Created by Roberto Frontado on 5/2/16.
//  Copyright © 2016 victoralbertos. All rights reserved.
//

internal class PlaceholderProvider: Provider {
    
    fileprivate let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    var lifeCache: LifeCache? { return provider.lifeCache }
    
    var dynamicKey: DynamicKey? { return provider.dynamicKey }
    
    var dynamicKeyGroup: DynamicKeyGroup? { return provider.dynamicKeyGroup }
    
    var evict: EvictProvider? { return nil  }
    
    var providerKey: String {
        return provider.providerKey
    }
    
}

internal class PlaceholderCacheProvider: PlaceholderProvider {
    
    override init(provider: Provider) {
        super.init(provider: provider)
    }
    
    override var evict: EvictProvider? { return nil  }
    
}

internal class PlaceholderEvictProvider: PlaceholderProvider {
    
    override init(provider: Provider) {
        super.init(provider: provider)
    }
    
    override var evict: EvictProvider? {
        if dynamicKey != nil {
            return EvictDynamicKey(evict: true)
        } else if dynamicKeyGroup != nil {
            return EvictDynamicKeyGroup(evict: true)
        } else {
            return EvictProvider(evict: true)
        }
    }
}
