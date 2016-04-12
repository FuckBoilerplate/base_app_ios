//
//  SearchUserPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/19/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class SearchUserPresenter: Presenter {

    private let repository: UserRepository
    
    init(wireframe: Wireframe, notificationRepository: NotificationRepository, repository: UserRepository) {
        self.repository = repository
        super.init(wireframe: wireframe, notificationRepository: notificationRepository)
    }
    
    func getUserByName(username: String) {
        let oUser: Observable<User> = repository.searchByUserName(username).safetyReportError(view)
        (view as! SearchUserViewController).showUser(oUser)
    }
    
}
