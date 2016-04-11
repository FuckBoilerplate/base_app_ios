//
//  RestApiTest.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/9/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
import Moya
import ObjectMapper
import Moya_ObjectMapper
@testable import base_app_ios

class RestApiTest: BaseTest {
    
    private let VALID_USERNAME = "RefineriaWeb"
    private let INVALID_USERNAME = ""
    
    var restApiUT: RestApi!
    
    override func setUp() {
        super.setUp()
        restApiUT = RestApiMoya()
    }
    
    func testWhenGetUserWithValidUserNameThenGetUserDemo() {

        var success = false
        restApiUT.getUser(VALID_USERNAME).mapObject(UserDemoEntity.self).subscribeNext { (user) -> Void in
            success = true
            expect(user.id).notTo(equal(0))
        }
        expect(success).toEventually(equal(true))
    }
    
    func testWhenGetUserWithInvalidUserNameThenThrowAnExceptionOnSubscriber() {
        
        var success = false
        restApiUT.getUser(INVALID_USERNAME).mapObject(UserDemoEntity.self).subscribeNext { (user) -> Void in
            success = true
            expect(user.id).to(beNil())
        }
        expect(success).toEventually(equal(true))
    }
    
    func testWhenGetUsersThenGetUsers() {
        
        var success = false
        restApiUT.getUsers().mapArray(UserDemoEntity.self).subscribeNext { (users) -> Void in
            success = true
            expect(users.count).notTo(equal(0))
        }
        expect(success).toEventually(equal(true))
    }
        
}
