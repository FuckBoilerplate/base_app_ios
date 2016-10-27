//
//  RestApiTest.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/9/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import XCTest
import RxSwift
import Moya
import ObjectMapper
import Moya_ObjectMapper
import Google
import Nimble
@testable import base_app_ios

class RestApiTest: XCTestCase {
    
    fileprivate let VALID_USERNAME = "RefineriaWeb"
    fileprivate let INVALID_USERNAME = ""
    
    var restApiUT: RestApi!
    
    override func setUp() {
        super.setUp()
        restApiUT = RestApiMoya()
    }
    
    func test1WhenGetUserWithValidUsernameThenGetUser() {
        var success = false
        
        restApiUT.getUserByName(VALID_USERNAME)
            .mapObject(User.self)
            .subscribe(onNext: { user in
                success = true
                expect(user.id).notTo(beNil())
                expect(user.id).notTo(equal(0))
        })
        expect(success).toEventually(beTrue())
    }
    
    func test2WhenGetuserWithInvalidUsernameThenGetANilUser() {
        var success = false
        
        restApiUT.getUserByName(INVALID_USERNAME)
            .mapObject(User.self)
            .subscribe(onNext: { user in
                success = true
                expect(user.id).to(beNil())
        })
        expect(success).toEventually(beTrue())
    }
    
    func test3WhenGetUsersThenGetUsers() {
        var success = false
        
        restApiUT.getUsers(nil, perPage: 25)
            .mapArray(User.self)
            .subscribe(onNext: { users in
                success = true
                expect(users.count).notTo(equal(0))
        })
        expect(success).toEventually(beTrue())
    }
}
