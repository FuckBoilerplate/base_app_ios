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

    override init(wireframeRepository: WireframeRepository) {
        super.init(wireframeRepository: wireframeRepository)
    }
    
    func getItemsMenu() -> Observable<[ItemMenu]> {
        var itemsMenu = [ItemMenu]()
        itemsMenu.append(ItemMenu(type: .users, title: "Users"))
        itemsMenu.append(ItemMenu(type: .user, title: "User"))
        itemsMenu.append(ItemMenu(type: .search, title: "Find user"))
        return Observable.just(itemsMenu)
    }

}

