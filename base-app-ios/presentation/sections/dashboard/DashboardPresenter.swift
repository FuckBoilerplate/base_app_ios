//
//  DashboardPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import OkDataSources

class DashboardPresenter: Presenter {

    override init(wireframe: Wireframe) {
        super.init(wireframe: wireframe)
    }
    
    func getItemsMenu() -> Observable<[ItemMenu]> {
        var itemsMenu = [ItemMenu]()
        itemsMenu.append(ItemMenu(type: .Users, title: "Users"))
        itemsMenu.append(ItemMenu(type: .User, title: "User"))
        itemsMenu.append(ItemMenu(type: .Search, title: "Find user"))
        return Observable.just(itemsMenu)
    }

}

