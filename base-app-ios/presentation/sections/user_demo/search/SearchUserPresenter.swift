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
    
    init(wireframe: Wireframe, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(wireframe: wireframe)
    }
    
    func getUserByName(username: String) {
        let oUser: Observable<User> = userRepository.searchByUserName(username).safetyReportError(view)
        (view as! SearchUserViewController).showUser(oUser)
    }
    
}
