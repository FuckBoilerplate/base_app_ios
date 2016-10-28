//
//  Array+RemoveObject.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/7/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: idx)
                    return true
                }
            }
        }
        return false
    }
}
