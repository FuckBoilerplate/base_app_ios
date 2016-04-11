//
//  UserDemoDataRepositoryTest.swift
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

class UserDemoDataRepositoryTest: BaseTest {
    
    private let VALID_USERNAME = "RefineriaWeb"
    private let INVALID_USERNAME = ""
    
    private var userDemoRepository: UserDemoDataRepositoryMock!
    
    override func setUp() {
        super.setUp()
        
        userDemoRepository = UserDemoDataRepositoryMock(restApi: RestApiMoya(), rxProviders: RxCache.Providers, uiData: uiDataMock)
    }
    
    func testWhenSearchWithValidUserNameThenGetDemoUser() {
        var success = false
        userDemoRepository.searchByUserName("valid").subscribeNext { (user) -> Void in
            success = true
            expect(user.id).notTo(equal(0))
        }
        expect(success).toEventually(equal(true))

    }

}
