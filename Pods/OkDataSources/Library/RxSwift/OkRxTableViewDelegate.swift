//
//  OkRxTableViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

public class OkRxTableViewDelegate<T: OkViewDataSource>: OkRxViewDelegate<T>, UITableViewDelegate {
    
    private var tableView: UITableView!
    
    public override init(dataSource: T, onItemClicked: @escaping (_ item: T.ItemType, _ position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(_ tableView: UITableView, onRefreshed: @escaping () -> Observable<[T.ItemType]>) {
        setOnPullToRefresh(tableView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(_ tableView: UITableView, onRefreshed: @escaping () -> Observable<[T.ItemType]>, refreshControl: UIRefreshControl?) {
        var refreshControl = refreshControl
        self.tableView = tableView
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        tableView.addSubview(refreshControl!)
    }
    
    override func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        super.refreshControlValueChanged(refreshControl)
        onRefreshed?()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { items in
                self.dataSource.items.removeAll()
                self.dataSource.items.append(contentsOf: items)
                self.tableView.reloadData()
            })
    }
    
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if dataSource.reverseItemsOrder {
            if reverseTriggerTreshold == indexPath.row
                && tableView.visibleCells.count > reverseTriggerTreshold {
                let reverseIndex = dataSource.items.count - indexPath.row - 1
                let item = dataSource.itemAtIndexPath(IndexPath(item: reverseIndex, section: 0))
                onPagination?(item)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { items in
                        if items.isEmpty { return }
                        self.dataSource.items.append(contentsOf: items)
                        let beforeHeight = tableView.contentSize.height
                        let beforeOffsetY = tableView.contentOffset.y
                        tableView.reloadData()
                        tableView.contentOffset = CGPoint(x: 0, y: (tableView.contentSize.height - beforeHeight + beforeOffsetY))
                })
            }
        } else {
            if (dataSource.items.count - triggerTreshold) == indexPath.row
                && indexPath.row > triggerTreshold {
                onPagination?(dataSource.items[indexPath.row])
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { items in
                        if items.isEmpty { return }
                        self.dataSource.items.append(contentsOf: items)
                        tableView.reloadData()
                })
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = dataSource.itemAtIndexPath(indexPath as IndexPath)
        
        if dataSource.reverseItemsOrder {
            let inverseIndex = dataSource.items.count - indexPath.row - 1
            item = dataSource.itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
            onItemClicked(item, inverseIndex)
        } else {
            onItemClicked(item, indexPath.row)
        }
    }
}
