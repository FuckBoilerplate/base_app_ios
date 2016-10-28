//
//  UsersTableViewCell.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import SDWebImage
import OkDataSources

class UsersTableViewCell: UITableViewCell, OkViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    func configureItem(_ item: User) {
        userNameLabel.text = item.login
        userImageView.image = nil
        if let imageURL = URL(string: item.getAvatarUrl()) {
            userImageView.sd_setImage(with: imageURL)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // If the cell is selected, deselect it!
        if selected {
            setSelected(false, animated: false)
        }
    }
}
