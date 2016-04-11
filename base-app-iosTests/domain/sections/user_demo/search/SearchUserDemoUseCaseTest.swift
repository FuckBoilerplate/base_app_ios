//
//  SearchUserDemoUseCaseTest.swift
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

class SearchUserDemoUseCaseTest: BaseTest {
    
    private var searchUserDemoUseCase: SearchUserDemoUseCase!
    private var userDemoDataRepositoryMock: UserDemoRepository!
    
    override func setUp() {
        super.setUp()
        
        userDemoDataRepositoryMock = UserDemoDataRepositoryMock(restApi: RestApiMoya(), rxProviders: RxCache.Providers, uiData: uiDataMock)
        searchUserDemoUseCase = SearchUserDemoUseCase(repository: userDemoDataRepositoryMock, uiDomain: uiDomainMock)
    }
    
    func testWhenGetUserWithValidNameGetUser() {
        var success = false
        searchUserDemoUseCase.setName("valid")
        searchUserDemoUseCase.react().subscribeNext { (user) -> Void in
            success = true
            expect(user.id).notTo(equal(0))
        }
        expect(success).toEventually(equal(true))
    }
    
    func testWhenGetUserWithInvalidNameGetError() {
        var success = false
        searchUserDemoUseCase.setName("invalid")
        searchUserDemoUseCase.react().subscribeError { (error) -> Void in
            success = true
        }
        expect(success).toEventually(equal(true))
    }

}
