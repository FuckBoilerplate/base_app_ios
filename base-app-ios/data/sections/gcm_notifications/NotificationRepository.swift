//
//  NotificationRepository.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import RxCache

class NotificationRepository: Repository {

    override init(restApi: RestApi, rxProviders: RxCache) {
        super.init(restApi: restApi, rxProviders: rxProviders)
    }
}
