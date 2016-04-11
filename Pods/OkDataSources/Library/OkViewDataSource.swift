//
//  OkViewDataSource.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

public protocol OkViewDataSource {
    typealias ItemType
    
    var items: [ItemType] { get set }
}

public extension OkViewDataSource {
    public func itemAtIndexPath(indexPath: NSIndexPath) -> ItemType {
        return items[indexPath.item]
    }
}