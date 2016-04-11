//
//  UserDemoDataRepositoryMock.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
@testable import base_app_ios

class UserDemoDataRepositoryMock: UserDemoDataRepository {
    
    override func getSelectedUserDemoList() -> Observable<UserDemoEntity> {
        return Observable.just(UserDemoEntity(id: 1, login: "", avatarUrl: ""))
    }
    
    override func askForUsers() -> Observable<[UserDemoEntity]> {
        return Observable.just([UserDemoEntity(id: 1, login: "", avatarUrl: "")])
    }
    
    override func saveSelectedUserDemoList(user: UserDemoEntity) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    override func searchByUserName(nameUser: String) -> Observable<UserDemoEntity> {
        if nameUser == "invalid" {
            return Observable.error(NSError(domain: "Invalid user name", code: 0, userInfo: nil))
        } else {
            return super.searchByUserName(nameUser)
        }
    }
}