//
//  OkViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/20/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

open class OkViewDelegate<T: OkViewDataSource>: NSObject {
    
    open var dataSource: T
    
    open let onItemClicked: (_ item: T.ItemType, _ position: Int) -> Void
    open var onRefreshed: ((_ refreshControl: UIRefreshControl) -> Void)?
    open var onPagination: ((_ item: T.ItemType) -> Void)?
    open var triggerTreshold: Int = 1
    open var reverseTriggerTreshold: Int = 0
    
    public init(dataSource: T, onItemClicked: @escaping (_ item: T.ItemType, _ position: Int) -> Void) {
        self.dataSource = dataSource
        self.onItemClicked = onItemClicked
    }
    
    // MARK: Private methods
    internal func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        onRefreshed?(refreshControl)
    }
    
    // MARK: - Public methods
    // MARK: Pagination
    open func setOnPagination(_ onPagination: @escaping (_ item: T.ItemType) -> Void) {
        setOnPagination(nil, onPagination: onPagination)
    }
    
    open func setOnPagination(_ triggerTreshold: Int?, onPagination: @escaping (_ item: T.ItemType) -> Void) {
        if let triggerTreshold = triggerTreshold {
            self.triggerTreshold = triggerTreshold
        }
        self.onPagination = onPagination
    }
    
    // MARK: Pull to refresh
    internal func configureRefreshControl(_ refreshControl: inout UIRefreshControl?, onRefreshed: @escaping (_ refreshControl: UIRefreshControl) -> Void) {
        self.onRefreshed = onRefreshed
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.gray
        }
        refreshControl!.addTarget(self, action: #selector(OkViewDelegate.refreshControlValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
}
