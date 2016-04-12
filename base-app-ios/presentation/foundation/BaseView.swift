//
//  BaseView.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

/**
* Base interface for any interface of type view. These interfaces will be implemented for the pertinent
* screen in the presentation layer
*/

import RxSwift

protocol BaseView {
    func showAlert(oTitle: Observable<String>)
    func showLoading()
    func hideLoading()
}
