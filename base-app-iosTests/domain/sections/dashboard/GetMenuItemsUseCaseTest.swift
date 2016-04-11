//
//  GetMenuItemsUseCaseTest.swift
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

class GetMenuItemsUseCaseTest: BaseTest {
    
    private var getMenuItemsUseCase: GetMenuItemsUseCase!
    private var dashboardItemsMenuMock: DashboardItemsMenu!

    override func setUp() {
        super.setUp()
        dashboardItemsMenuMock = DashboardItemsMenuDomain()
        getMenuItemsUseCase = GetMenuItemsUseCase(dashboardItemsMenu: dashboardItemsMenuMock, uiDomain: uiDomainMock)
    }
    
    func testWhenExecuteGetItemsMenu() {
        var success = false
        getMenuItemsUseCase.react().subscribeNext { (items) -> Void in
            success = true
            expect(items.count).to(equal(3))
        }
        expect(success).toEventually(equal(true))
    }
}
