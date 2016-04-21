//
//  Array+RemoveObject.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/7/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}