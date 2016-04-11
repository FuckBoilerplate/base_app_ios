//
//  GetUsersDemoUseCaseTest.swift
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

class GetUsersDemoUseCaseTest: BaseTest {
    
    private var getUsersDemoUseCase: GetUsersDemoUseCase!
    private var userDemoDataRepositoryMock: UserDemoRepository!
    
    override func setUp() {
        super.setUp()
        
        userDemoDataRepositoryMock = UserDemoDataRepositoryMock(restApi: RestApiMoya(), rxProviders: RxCache.Providers, uiData: uiDataMock)
        getUsersDemoUseCase = GetUsersDemoUseCase(repository: userDemoDataRepositoryMock, uiDomain: uiDomainMock)
    }
    
    func testWhenExecuteGetUsers() {
        var success = false
        getUsersDemoUseCase.react().subscribeNext { (users) -> Void in
            success = true
            expect(users.count).to(equal(1))
        }
        expect(success).toEventually(equal(true))
    }

}
