//
//  OkTableViewDelegate.swift
//  OkDataSources
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

public class OkTableViewDelegate<T: OkViewDataSource, U: OkViewCellDelegate where T.ItemType == U.ItemType>: NSObject, UITableViewDelegate {
    private let dataSource: T
    private let presenter: U
    
    public init(dataSource: T, presenter: U) {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.itemAtIndexPath(indexPath)
        presenter.onItemClick(item, position: indexPath.row)
    }
}
