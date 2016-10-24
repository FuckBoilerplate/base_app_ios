//
//  OkCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

open class OkCollectionViewDelegate<T: OkViewDataSource>: OkViewDelegate<T>, UICollectionViewDelegate {
    
    public override init(dataSource: T, onItemClicked: @escaping(_ item: T.ItemType, _ position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    open func setOnPullToRefresh(_ collectionView: UICollectionView, onRefreshed: @escaping(_ refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(collectionView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    open func setOnPullToRefresh(_ collectionView: UICollectionView, onRefreshed: @escaping(_ refreshControl: UIRefreshControl) -> Void, refreshControl: UIRefreshControl?) {
        var refreshControl = refreshControl
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if dataSource.reverseItemsOrder {
            if reverseTriggerTreshold == (indexPath as NSIndexPath).row
                && collectionView.visibleCells.count > reverseTriggerTreshold {
                let inverseIndex = dataSource.items.count - (indexPath as NSIndexPath).row - 1
                let item = dataSource.itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
                onPagination?(item)
            }
        } else {
            if (dataSource.items.count - triggerTreshold) == (indexPath as NSIndexPath).row
                && (indexPath as NSIndexPath).row > triggerTreshold {
                    onPagination?(dataSource.items[(indexPath as NSIndexPath).row])
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
