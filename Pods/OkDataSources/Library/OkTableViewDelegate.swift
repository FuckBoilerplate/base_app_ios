//
//  OkTableViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkTableViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: OkViewDelegate<T.ItemType>, UITableViewDelegate {
    
    public let dataSource: T
    public let presenter: U
    
    private var tableView: UITableView!
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(tableView: UITableView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(tableView, onRefreshedBlock: onRefreshedBlock, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(tableView: UITableView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void, var refreshControl: UIRefreshControl?) {
        configureRefreshControl(&refreshControl, onRefreshedBlock: onRefreshedBlock)
        self.tableView = tableView
        tableView.addSubview(refreshControl!)
    }
    
    // MARK: UITableViewDelegate
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if (dataSource.items.count - triggerTreshold) == indexPath.row && indexPath.row > triggerTreshold {
            onPaginationBlock(item: dataSource.items[indexPath.row])
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}
