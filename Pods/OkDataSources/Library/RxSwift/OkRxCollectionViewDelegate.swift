//
//  OkRxCollectionViewDelegate.swift
//  OkDataSourcesExample
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

public class OkRxCollectionViewDelegate<T: OkViewDataSource>: OkRxViewDelegate<T>, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    
    public override init(dataSource: T, onItemClicked: (item: T.ItemType, position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshed: () -> Observable<[T.ItemType]>) {
        setOnPullToRefresh(collectionView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshed: () -> Observable<[T.ItemType]>, var refreshControl: UIRefreshControl?) {
        self.collectionView = collectionView
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    override func refreshControlValueChanged(refreshControl: UIRefreshControl) {
        super.refreshControlValueChanged(refreshControl)
        onRefreshed()
            .subscribeNext { items in
                self.dataSource.items.removeAll()
                self.dataSource.items.appendContentsOf(items)
                self.collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if (dataSource.items.count - triggerTreshold) == indexPath.row && indexPath.row > triggerTreshold {
            onPagination?(item: dataSource.items[indexPath.row])
                .subscribeNext { items in
                    self.dataSource.items.appendContentsOf(items)
                    collectionView.reloadData()
            }
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        onItemClicked(item: item, position: indexPath.row)
    }
}