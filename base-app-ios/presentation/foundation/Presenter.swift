//
//  Presenter.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**
 Base class for any Presenter.
 The presenter is responsible for linking the uses cases in order to create a logical unit
 which will be represented as a screen in the application.
 
 - Parameters:
 - V: The view interface attached to this presenter.
 - See: [BaseView.swift](BaseView.swift)
 - W: The wireframe interface attached to this presenter.
 - See: [Wireframe.swift](Wireframe.swift)
 
 */

class Presenter {
    
    internal let wireframeRepository: WireframeRepository
    
    init(wireframeRepository: WireframeRepository) {
        self.wireframeRepository = wireframeRepository
    }
    
    func dataForNextScreen<T>(_ object: T) -> Observable<Void> {
        return wireframeRepository.setWireframeCurrentObject(object)
    }
}
