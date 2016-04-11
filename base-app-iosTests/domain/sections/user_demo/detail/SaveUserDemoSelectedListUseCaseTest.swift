//
//  SaveUserDemoSelectedListUseCaseTest.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
import Moya
import ObjectMapper
import Moya_ObjectMapper
@testable import base_app_ios

class SaveUserDemoSelectedListUseCaseTest: BaseTest {
    
    private var saveUserDemoSelectedListUseCase: SaveUserDemoSelectedListUseCase!
    private var userDemoDataRepositoryMock: UserDemoRepository!
    
    override func setUp() {
        super.setUp()
        
        userDemoDataRepositoryMock = UserDemoDataRepositoryMock(restApi: RestApiMoya(), rxProviders: RxCache.Providers, uiData: uiDataMock)
        saveUserDemoSelectedListUseCase = SaveUserDemoSelectedListUseCase(repository: userDemoDataRepositoryMock, uiDomain: uiDomainMock)
    }

    func testWhenSaveUserThenGetBooleanObservable() {
        var success = false
        saveUserDemoSelectedListUseCase.setUserDemoEntity(UserDemoEntity(id: 0, login: "", avatarUrl: ""))
        saveUserDemoSelectedListUseCase.react().subscribeNext { (saved) -> Void in
            success = true
            expect(saved).to(equal(true))
        }
        expect(success).toEventually(equal(true))
    }

}
