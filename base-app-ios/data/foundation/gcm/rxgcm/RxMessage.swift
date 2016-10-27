//
//  RxMessage.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

open class RxMessage {
    fileprivate let from: String!
    fileprivate let payload: [AnyHashable: Any]!
    fileprivate let target: String!
    
    init(from: String, payload: [AnyHashable: Any], target: String){
        self.from = from
        self.payload = payload
        self.target = target
    }
    
    open func getFrom() -> String {
        return from
    }
    
    open func getTarget() -> String {
        return target
    }
    
    open func getPayload() -> [AnyHashable: Any] {
        return payload
    }
}
