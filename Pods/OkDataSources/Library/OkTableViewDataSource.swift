//
//  OkTableViewDataSource.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

open class OkTableViewDataSource<U, V: OkViewCell>: NSObject, UITableViewDataSource, OkViewDataSource where U == V.ItemType {
    open var items = [U]()
    open var reverseItemsOrder = false
    
    public override init() {
        super.init()
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: V.identifier, for: indexPath)
        var item = itemAtIndexPath(indexPath)
        
        if reverseItemsOrder {
            let inverseIndex = items.count - (indexPath as NSIndexPath).row - 1
            item = itemAtIndexPath(IndexPath(item: inverseIndex, section: 0))
        }
        
        (cell as! V).configureItem(item)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
