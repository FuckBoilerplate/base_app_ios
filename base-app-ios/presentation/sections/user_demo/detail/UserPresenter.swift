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
    
    func getCurrentUser() -> Observable<User> {
        return wireframe.getWireframeCurrentObject()
    }
    
    func goToSearchScreen() -> Observable<Void> {
        return Observable.deferred {
            self.wireframe.searchUserScreen()
            return Observable.just()
        }
    }
}
