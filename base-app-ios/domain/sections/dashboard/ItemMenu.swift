//
//  ItemMenu.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

class ItemMenu {
    
    enum Type {
        case Users
        case User
        case Search
    }
    
    let type: Type
    var title: String!
    
    init(type: Type, title: String) {
        self.type = type
        self.title = title
    }
}