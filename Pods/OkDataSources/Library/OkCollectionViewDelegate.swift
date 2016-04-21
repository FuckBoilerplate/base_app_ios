//
//  OkCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkCollectionViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: OkViewDelegate<T.ItemType>, UICollectionViewDelegate {
    
    public let dataSource: T
    public let presenter: U
    
    private var collectionView: UICollectionView!
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    // MARK: - Public methods
    // MARK: Pull to refresh
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void) {
        setOnPullToRefresh(collectionView, onRefreshedBlock: onRefreshedBlock, refreshControl: nil)
    }
    
    public func setOnPullToRefresh(collectionView: UICollectionView, onRefreshedBlock: (refreshControl: UIRefreshControl) -> Void, var refreshControl: UIRefreshControl?) {
        configureRefreshControl(&refreshControl, onRefreshedBlock: onRefreshedBlock)
        collectionView.addSubview(refreshControl!)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: UICollectionViewDelegate
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // Ask for nextPage every time the user is getting close to the trigger treshold
        if (dataSource.items.count - triggerTreshold) == indexPath.row && indexPath.row > triggerTreshold {
            onPaginationBlock(item: dataSource.items[indexPath.row])
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}