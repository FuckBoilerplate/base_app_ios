//
//  GetSelectedDemoUserListUseCaseTest.swift
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

class GetSelectedDemoUserListUseCaseTest: BaseTest {
    
    private var getSelectedDemoUserListUseCase: GetSelectedDemoUserListUseCase!
    private var userDemoDataRepositoryMock: UserDemoRepository!
    private var userDemoEntityMock: UserDemoEntity!
    
    override func setUp() {
        super.setUp()
        
        userDemoDataRepositoryMock = UserDemoDataRepositoryMock(restApi: RestApiMoya(), rxProviders: RxCache.Providers, uiData: uiDataMock)
        getSelectedDemoUserListUseCase = GetSelectedDemoUserListUseCase(repository: userDemoDataRepositoryMock, uiDomain: uiDomainMock)
    }
    
    func testWhenExecuteGetUser() {
        var success = false
        getSelectedDemoUserListUseCase.react().subscribeNext { (user) -> Void in
            success = true
            expect(user.id).to(equal(1))
        }
        expect(success).toEventually(equal(true))
    }

}
