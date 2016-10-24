//
//  DashboardTableViewCell.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/17/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import OkDataSources

@objc
class DashboardTableViewCell: UITableViewCell, OkViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    func configureItem(_ item: ItemMenu) {
        titleLabel.text = item.title
    }
}
