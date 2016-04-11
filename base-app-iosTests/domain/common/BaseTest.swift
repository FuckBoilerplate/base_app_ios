//
//  BaseTest.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 3/9/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import XCTest
import RxSwift
import Nimble
@testable import base_app_ios

class BaseTest: XCTestCase {
    internal static let WAIT = 50
    internal var observeOnMock: ObserveOn!
    internal var subscribeOnMock: SubscribeOn!
    internal var uiDomainMock: UIDomain!
    internal var uiDataMock: UIData!
    
    override func setUp() {
        observeOnMock = ObserveOnMock()
        subscribeOnMock = SubscribeOnMock()
        uiDomainMock = UIDomainImplementation()
        uiDataMock = UIDataImplementation()
    }
    
    class ObserveOnMock: ObserveOn {
        func getScheduler() -> ImmediateSchedulerType {
            return MainScheduler.instance
        }
    }
    
    class SubscribeOnMock: SubscribeOn {
        func getScheduler() -> ImmediateSchedulerType {
            return ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: DispatchQueueSchedulerQOS.Background)
        }
    }
    
}