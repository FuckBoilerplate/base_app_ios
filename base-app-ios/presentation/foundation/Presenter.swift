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
    
    internal let wireframe: Wireframe
    
    init(wireframe: Wireframe) {
        self.wireframe = wireframe
    }
    
    func back() -> Observable<Void> {
        return Observable.deferred { () -> Observable<Void> in
            self.wireframe.popCurrentScreen()
            return Observable.just()
        }
    }
}
