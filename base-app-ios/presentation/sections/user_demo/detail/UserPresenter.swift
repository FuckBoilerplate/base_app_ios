//
//  UserPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class UserPresenter: Presenter {

    private let repository: UserRepository
    
    init(wireframe: Wireframe, notificationRepository: NotificationRepository, repository: UserRepository) {
        self.repository = repository
        super.init(wireframe: wireframe, notificationRepository: notificationRepository)
    }
    
    override func attachView(view: BaseView) {
        super.attachView(view)
        
        safetyReportError(wireframe.getWireframeCurrentObject())
            .disposable { oUser in (view as! UserViewController).showUser(oUser) }
    }
    
    func goToSearchScreen() {
        wireframe.searchUserScreen()
    }
}
