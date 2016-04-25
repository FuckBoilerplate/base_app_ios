//
//  UsersPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import OkDataSources

class UsersPresenter: Presenter {

    private let userRepository: UserRepository

    init(wireframeRepository: WireframeRepository, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(wireframeRepository: wireframeRepository)
    }

    func nextPage(user: User?) -> Observable<[User]> {
        return userRepository.getUsers(user?.id, refresh: false)
    }

    func refreshList() -> Observable<[User]> {
        return userRepository.getUsers(nil, refresh: true)
    }

}