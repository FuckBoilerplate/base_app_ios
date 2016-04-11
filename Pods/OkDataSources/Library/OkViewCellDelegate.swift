//
//  OkViewCellDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/8/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

public protocol OkViewCellDelegate {
    typealias ItemType
    func onItemClick(item: ItemType, position: Int)
}
