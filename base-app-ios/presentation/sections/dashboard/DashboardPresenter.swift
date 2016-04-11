//
//  DashboardPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import OkDataSources

class DashboardPresenter: Presenter, OkViewCellDelegate {
    
    private let ID_USERS = 1
    private let ID_USER = 2
    private let ID_SEARCH = 3

    override init(wireframe: Wireframe, notificationRepository: NotificationRepository) {
        super.init(wireframe: wireframe, notificationRepository: notificationRepository)
    }
    
    override func attachView(view: BaseView) {
        super.attachView(view)
        safetyReportError(itemsMenu())
            .disposable { oItemsMenu in (self.view as! DashboardViewController).showItemsMenu(oItemsMenu) }
    }
    
    private func itemsMenu() -> Observable<[ItemMenu]> {
        var itemsMenu = [ItemMenu]()
        itemsMenu.append(ItemMenu(id: ID_USERS, title: "Users"))
        itemsMenu.append(ItemMenu(id: ID_USER, title: "User"))
        itemsMenu.append(ItemMenu(id: ID_SEARCH, title: "Find user"))
        return Observable.just(itemsMenu)
    }
    
    private func setSelectedItemMenu(itemMenu: ItemMenu) {
        if itemMenu.id == ID_USERS {
            (view as! DashboardViewController).showUsers()
        } else if itemMenu.id == ID_USER {
            (view as! DashboardViewController).showUser()
        } else if itemMenu.id == ID_SEARCH {
            (view as! DashboardViewController).showUserSearch()
        }
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: ItemMenu, position: Int) {
        setSelectedItemMenu(item)
    }

}

