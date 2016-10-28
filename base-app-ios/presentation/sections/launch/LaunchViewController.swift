//
//  LaunchViewController.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import SystemConfiguration

class LaunchViewController: BaseViewController<LaunchPresenter> {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wireframe.dashboard()
    }
}
