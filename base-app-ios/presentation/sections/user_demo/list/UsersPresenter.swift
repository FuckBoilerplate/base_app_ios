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
        let oUsers: Observable<[User]> = repository.askForUsers().safetyReportError(view)
        (view as! UsersViewController).showUsers(oUsers)
    }
    
    private func goToDetail(user: User) {
        wireframe.setWireframeCurrentObject(user)
            .safetyReportError(view)
            .subscribeNext { self.wireframe.userScreen() }
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: User, position: Int) {
        goToDetail(item)
    }
}