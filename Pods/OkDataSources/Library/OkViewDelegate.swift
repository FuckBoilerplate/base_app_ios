//
//  OkViewDelegate.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/20/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkViewDelegate<T>: NSObject {
    
    public var onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void = { _ in return }
    public var onPaginationBlock: (item: T) -> Void = { _ in return }
    public var triggerTreshold: Int = 1
    
    public override init() {}
    
    // MARK: Private methods
    internal func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        onRefreshedBlock(refreshControl: refreshControl)
    }
    
    // MARK: - Public methods
    // MARK: Pagination
    public func setOnPagination(onPaginationBlock: (item: T) -> Void) {
        setOnPagination(nil, onPaginationBlock: onPaginationBlock)
    }
    
    public func setOnPagination(triggerTreshold: Int?, onPaginationBlock: (item: T) -> Void) {
        if let triggerTreshold = triggerTreshold {
            self.triggerTreshold = triggerTreshold
        }
        self.onPaginationBlock = onPaginationBlock
    }
    
    // MARK: Pull to refresh
    internal func configureRefreshControl(inout refreshControl: UIRefreshControl?, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        self.onRefreshedBlock = onRefreshedBlock
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.grayColor()
        }
        refreshControl!.addTarget(self, action: "refreshControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
}