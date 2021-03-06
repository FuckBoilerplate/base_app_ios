//
//  DataModule.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Swinject
import RxCache

class DataModule {
    
    static func setup(_ defaultContainer: Container) {
        
        defaultContainer.register(RxCache.self) { _ in RxCache.Providers }
        
        defaultContainer.register(RestApi.self) { _ in RestApiMoya() }
            .inObjectScope(.container)
        
        // Repositories
        
        defaultContainer.register(WireframeRepository.self) { r in
            WireframeRepository(restApi: r.resolve(RestApi.self)!, rxProviders: r.resolve(RxCache.self)!) }
            .inObjectScope(.container)
        
        defaultContainer.register(UserRepository.self) { r in
            UserRepository(restApi: r.resolve(RestApi.self)!, rxProviders: r.resolve(RxCache.self)!) }
            .inObjectScope(.container)
    }
}
