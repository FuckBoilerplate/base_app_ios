//
//  ItemMenu.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

class ItemMenu {
    
    enum ItemType {
        case users
        case user
        case search
    }
    
    let type: ItemType
    var title: String!
    
    init(type: ItemType, title: String) {
        self.type = type
        self.title = title
    }
}
