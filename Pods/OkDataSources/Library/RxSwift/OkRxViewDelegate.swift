//
//  OkRxViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/20/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

public class OkRxViewDelegate<T: OkViewDataSource>: NSObject {
    
    public var dataSource: T
    
    public let onItemClicked: (_ item: T.ItemType, _ position: Int) -> Void
    public var onRefreshed: (() -> Observable<[T.ItemType]>)?
    public var onPagination: ((_ item: T.ItemType) -> Observable<[T.ItemType]>)?
    public var triggerTreshold: Int = 1
    public var reverseTriggerTreshold: Int = 0
    
    public init(dataSource: T, onItemClicked: @escaping (_ item: T.ItemType, _ position: Int) -> Void) {
        self.dataSource = dataSource
        self.onItemClicked = onItemClicked
    }
    
    // MARK: Private methods
    internal func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Public methods
    // MARK: Pagination
    public func setOnPagination(onPagination: @escaping (_ item: T.ItemType) -> Observable<[T.ItemType]>) {
        setOnPagination(nil, onPagination: onPagination)
    }
    
    public func setOnPagination(_ triggerTreshold: Int?, onPagination: @escaping (_ item: T.ItemType) -> Observable<[T.ItemType]>) {
        if let triggerTreshold = triggerTreshold {
            self.triggerTreshold = triggerTreshold
        }
        self.onPagination = onPagination
    }
    
    // MARK: Pull to refresh
    internal func configureRefreshControl(_ refreshControl: inout UIRefreshControl?, onRefreshed: @escaping () -> Observable<[T.ItemType]>) {
        self.onRefreshed = onRefreshed
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.gray
        }
        refreshControl!.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
    }
    
}
