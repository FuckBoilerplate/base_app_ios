//
//  SearchUserPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/19/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class SearchUserPresenter: Presenter {

    private let userRepository: UserRepository
    
    init(wireframeRepository: WireframeRepository, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(wireframeRepository: wireframeRepository)
    }
    
    func getUserByName(username: String) -> Observable<User> {
        return userRepository.searchByUserName(username)
    }
    
}
