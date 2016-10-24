//
//  OkTableViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

open class OkTableViewDelegate<T: OkViewDataSource>: OkViewDelegate<T>, UITableViewDelegate {
    
    public override init(dataSource: T, onItemClicked: @escaping(_ item: T.ItemType, _ position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    open func setOnPullToRefresh(_ tableView: UITableView, onRefreshed: @escaping (_ refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(tableView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(_ tableView: UITableView, onRefreshed: @escaping (_ refreshControl: UIRefreshControl) -> Void, refreshControl: UIRefreshControl?) {
        var refreshControl = refreshControl
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        tableView.addSubview(refreshControl!)
    }
    
    // MARK: UITableViewDelegate
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if dataSource.reverseItemsOrder {
            if reverseTriggerTreshold == (indexPath as NSIndexPath).row
                && tableView.visibleCells.count > reverseTriggerTreshold {
                let inverseIndex = dataSource.items.count - (indexPath as NSIndexPath).row - 1
                let item = dataSource.itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
                onPagination?(item)
            }
        } else {
            if (dataSource.items.count - triggerTreshold) == (indexPath as NSIndexPath).row
                && (indexPath as NSIndexPath).row > triggerTreshold {
                    onPagination?(dataSource.items[indexPath.row])
            }
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = dataSource.itemAtIndexPath(indexPath)
        
        if dataSource.reverseItemsOrder {
            let inverseIndex = dataSource.items.count - indexPath.row - 1
            item = dataSource.itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
            onItemClicked(item, inverseIndex)
        } else {
            onItemClicked(item, indexPath.row)
        }
    }
}
