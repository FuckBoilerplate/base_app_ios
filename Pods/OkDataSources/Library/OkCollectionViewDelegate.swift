//
//  OkCollectionViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkCollectionViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: NSObject, UICollectionViewDelegate {
    internal let dataSource: T
    internal let presenter: U
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}