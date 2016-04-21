//
//  UserPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class UserPresenter: Presenter {
    
    override init(wireframe: Wireframe) {
        super.init(wireframe: wireframe)
    }
    
    override func attachView(view: BaseView) {
        super.attachView(view)
        let oUser: Observable<User> = wireframe.getWireframeCurrentObject().safetyReportError(view)
        (view as! UserViewController).showUser(oUser)
    }
    
    func goToSearchScreen() {
        wireframe.searchUserScreen()
    }
}
