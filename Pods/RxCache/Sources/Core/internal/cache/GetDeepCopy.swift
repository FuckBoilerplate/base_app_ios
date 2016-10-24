//
//  GetDeepCopy.swift
//  RxCache
//
//  Created by Roberto Frontado on 4/15/16.
//  Copyright © 2016 victoralbertos. All rights reserved.
//

class GetDeepCopy {
    
    func getDeepCopy<T>(objects: [T]) -> [T] {
        
        // Validates that T is a Class, not a Struct
        if !(T.self is AnyClass) {
            return objects
        }
        
        return objects.map { (object) -> T in
            if let cacheable = T.self as? Cacheable.Type,
                let data = object as? Cacheable,
                let json = data.toJSON() {
                return cacheable.init(json: json) as! T
            } else {
                fatalError((String(describing: T.self) + Locale.CacheableIsNotEnought))
            }
        }
    }
}
