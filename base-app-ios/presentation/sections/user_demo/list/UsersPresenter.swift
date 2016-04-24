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

    init(wireframe: Wireframe, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(wireframe: wireframe)
    }
    
    func goToDetail(user: User) -> Observable<Void> {
        return wireframe.setWireframeCurrentObject(user)
            .doOn(onNext: { self.wireframe.userScreen() } )
    }
    
    func nextPage(user: User?) -> Observable<[User]> {
        return userRepository.getUsers(user?.id, refresh: false)
    }

    func refreshList() -> Observable<[User]> {
        return userRepository.getUsers(nil, refresh: true)
    }

}