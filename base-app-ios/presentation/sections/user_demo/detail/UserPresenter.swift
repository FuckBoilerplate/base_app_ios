//
//  UserPresenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class UserPresenter: Presenter {
    
    override init(wireframeRepository: WireframeRepository) {
        super.init(wireframeRepository: wireframeRepository)
    }
    
    func getCurrentUser() -> Observable<User> {
        return wireframeRepository.getWireframeCurrentObject()
    }
}
