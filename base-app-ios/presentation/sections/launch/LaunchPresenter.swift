//
//  LaunchPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class LaunchPresenter: Presenter {

    override init(wireframe: Wireframe, notificationRepository: NotificationRepository) {
        super.init(wireframe: wireframe, notificationRepository: notificationRepository)
    }

    override func resumeView() {
        super.resumeView()
        wireframe.dashboard()
    }
}
