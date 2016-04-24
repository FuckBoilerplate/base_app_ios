//
//  LaunchViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController<LaunchPresenter> {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presenter.wireframe.dashboard()
    }
}

