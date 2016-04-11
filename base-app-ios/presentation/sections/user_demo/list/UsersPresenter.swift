//
//  UsersPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import OkDataSources

class UsersPresenter: Presenter, OkViewCellDelegate {

    private let repository: UserRepository

    init(wireframe: Wireframe, notificationRepository: NotificationRepository, repository: UserRepository) {
        self.repository = repository
        super.init(wireframe: wireframe, notificationRepository: notificationRepository)
    }
    
    override func attachView(view: BaseView) {
        super.attachView(view)
        
        safetyReportError(repository.askForUsers()).disposable { (oUsers) -> Disposable in
            (view as! UsersViewController).showUsers(oUsers)
        }
    }
    
    private func goToDetail(user: User) {
        safetyReportError(wireframe.setWireframeCurrentObject(user))
            .disposable { oSuccess in
                oSuccess.subscribeNext { self.wireframe.userScreen() }
        }
        
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: User, position: Int) {
        goToDetail(item)
    }
}