//
//  OkViewCell.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

public protocol OkViewCell {
    static var reuseIdentifier: String { get }
    static var identifier: String { get }
    
    typealias ItemType
    
    func configureItem(item: ItemType)
}

public extension OkViewCell {
    public static var reuseIdentifier: String { return String(Self) + "ReuseIdentifier" }
    public static var identifier: String { return String(Self) + "Identifier" }
}