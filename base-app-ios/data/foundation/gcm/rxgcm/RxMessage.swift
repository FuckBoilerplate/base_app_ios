//
//  RxMessage.swift
//  RxGcm_swift
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import Foundation

public class RxMessage {
    private let from: String!
    private let payload: [NSObject : AnyObject]!
    private let target: String!
    
    init(from: String, payload: [NSObject : AnyObject], target: String){
        self.from = from
        self.payload = payload
        self.target = target
    }
    
    public func getFrom() -> String {
        return from
    }
    
    public func getTarget() -> String {
        return target
    }
    
    public func getPayload() -> [NSObject : AnyObject] {
        return payload
    }
}