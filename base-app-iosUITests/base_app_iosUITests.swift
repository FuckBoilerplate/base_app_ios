//
//  base_app_iosUITests.swift
//  base-app-iosUITests
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import XCTest
@testable import base_app_ios

class base_app_iosUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        sleep(1)
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        
        let userNavigationBar = app.navigationBars["User"]
        userNavigationBar.buttons["Users"].tap()
        sleep(1)
        app.navigationBars["Users"].buttons["Menu"].tap()
        sleep(1)
        
        let tablesQuery = app.tables
        tablesQuery.cells["User"].tap()
        sleep(1)
        userNavigationBar.buttons["Menu"].tap()
        sleep(1)
        tablesQuery.staticTexts["Find user"].tap()
        sleep(1)
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("valid")
        app.buttons["Find user"].tap()
        sleep(1)
    }
    
}
