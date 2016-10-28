//
//  OkRxCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

public class OkRxCollectionViewDelegate<T: OkViewDataSource>: OkRxViewDelegate<T>, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    
    public override init(dataSource: T, onItemClicked: @escaping (_ item: T.ItemType, _ position: Int) -> Void) {
        super.init(dataSource: dataSource, onItemClicked: onItemClicked)
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(_ collectionView: UICollectionView, onRefreshed: @escaping () -> Observable<[T.ItemType]>) {
        setOnPullToRefresh(collectionView, onRefreshed: onRefreshed, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(_ collectionView: UICollectionView, onRefreshed: @escaping () -> Observable<[T.ItemType]>, refreshControl: UIRefreshControl?) {
        var refreshControl = refreshControl
        self.collectionView = collectionView
        configureRefreshControl(&refreshControl, onRefreshed: onRefreshed)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    override func refreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        super.refreshControlValueChanged(refreshControl)
        onRefreshed?()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { items in
                self.dataSource.items.removeAll()
                self.dataSource.items.append(contentsOf: items)
                self.collectionView.reloadData()
        })
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if dataSource.reverseItemsOrder {
            if reverseTriggerTreshold == indexPath.row
                && collectionView.visibleCells.count > reverseTriggerTreshold {
                let reverseIndex = dataSource.items.count - indexPath.row - 1
                let item = dataSource.itemAtIndexPath(IndexPath(item: reverseIndex, section: 0))
                onPagination?(item)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { items in
                        if items.isEmpty { return }
                        self.dataSource.items.append(contentsOf: items)
                        let beforeHeight = collectionView.contentSize.height
                        let beforeOffsetY = collectionView.contentOffset.y
                        collectionView.reloadData()
                        collectionView.layoutIfNeeded()
                        collectionView.contentOffset = CGPoint(x: 0, y: (collectionView.contentSize.height - beforeHeight + beforeOffsetY))
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
                        collectionView.reloadData()
                })
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
