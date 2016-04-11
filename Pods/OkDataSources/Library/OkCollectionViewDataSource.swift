//
//  OkCollectionViewDataSource.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/19/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkCollectionViewDataSource<U, V: OkViewCell where U == V.ItemType>
: NSObject, UICollectionViewDataSource, OkViewDataSource {
    public var items = [U]()
    
    public override init() {
        super.init()
    }
    
    public func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return items.count
    }
    
    public func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                V.reuseIdentifier,
                forIndexPath: indexPath
            )
            let item = itemAtIndexPath(indexPath)
            (cell as! V).configureItem(item)
            return cell
    }

}
