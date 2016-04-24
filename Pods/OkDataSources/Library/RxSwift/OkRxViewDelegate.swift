//
//  OkRxViewDelegate.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/20/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

public class OkRxViewDelegate<T: OkViewDataSource>: NSObject {
    
    public var dataSource: T
    
    internal let onItemClicked: (item: T.ItemType, position: Int) -> Void
    internal var onRefreshed: (() -> Observable<[T.ItemType]>)!
    internal var onPagination: ((item: T.ItemType) -> Observable<[T.ItemType]>)!
    public var triggerTreshold: Int = 1
    
    public init(dataSource: T, onItemClicked: (item: T.ItemType, position: Int) -> Void) {
        self.dataSource = dataSource
        self.onItemClicked = onItemClicked
    }
    
    // MARK: Private methods
    internal func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Public methods
    // MARK: Pagination
    public func setOnPagination(onPagination: (item: T.ItemType) -> Observable<[T.ItemType]>) {
        setOnPagination(nil, onPagination: onPagination)
    }
    
    public func setOnPagination(triggerTreshold: Int?, onPagination: (item: T.ItemType) -> Observable<[T.ItemType]>) {
        if let triggerTreshold = triggerTreshold {
            self.triggerTreshold = triggerTreshold
        }
        self.onPagination = onPagination
    }
    
    // MARK: Pull to refresh
    internal func configureRefreshControl(inout refreshControl: UIRefreshControl?, onRefreshed: () -> Observable<[T.ItemType]>) {
        self.onRefreshed = onRefreshed
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.grayColor()
        }
        refreshControl!.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
}