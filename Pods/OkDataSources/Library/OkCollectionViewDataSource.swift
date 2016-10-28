//
//  OkCollectionViewDataSource.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/19/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

open class OkCollectionViewDataSource<U, V: OkViewCell>
: NSObject, UICollectionViewDataSource, OkViewDataSource where U == V.ItemType {
    open var items = [U]()
    open var reverseItemsOrder = false
    
    public override init() {
        super.init()
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return items.count
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: V.reuseIdentifier,
                for: indexPath
            )
            var item = itemAtIndexPath(indexPath)
            
            if reverseItemsOrder {
                let inverseIndex = items.count - (indexPath as NSIndexPath).row - 1
                item = itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
            }
            
            (cell as! V).configureItem(item)
            return cell
    }

}
