//
//  Cacheable.swift
//  RxCache
//
//  Created by Roberto Frontado on 10/3/16.
//  Copyright © 2016 victoralbertos. All rights reserved.
//

public typealias JSON = [String : Any]

public protocol Cacheable {
    
    init?(json: JSON)
    func toJSON() -> JSON?
}


