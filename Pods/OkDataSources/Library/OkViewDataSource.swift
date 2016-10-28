//
//  OkViewDataSource.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

public protocol OkViewDataSource {
    associatedtype ItemType
    
    var items: [ItemType] { get set }
    var reverseItemsOrder: Bool { get set }
}

public extension OkViewDataSource {
    
    public func itemAtIndexPath(_ indexPath: IndexPath) -> ItemType {
        return items[(indexPath as NSIndexPath).item]
    }
}
