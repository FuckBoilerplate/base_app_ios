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

    private let userRepository: UserRepository

    init(wireframe: Wireframe, userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init(wireframe: wireframe)
    }
    
    override func attachView(view: BaseView) {
        super.attachView(view)
        nextPage(nil)
    }
    
    func goToDetail(user: User) {
        wireframe.setWireframeCurrentObject(user)
            .safetyReportError(view)
            .subscribeNext { self.wireframe.userScreen() }
    }
    
    func nextPage(user: User?) {
        let oUsers = userRepository.getUsers(user?.id, refresh: false).safetyReportError(view)
        (view as! UsersViewController).showMoreUsers(oUsers)
    }
    
    func refreshList() {
        let oUsers = userRepository.getUsers(nil, refresh: true).safetyReportError(view)
        (view as! UsersViewController).showUsers(oUsers)
    }
    
    // MARK: - OkViewCellDelegate
    func onItemClick(item: User, position: Int) {
        goToDetail(item)
    }
}