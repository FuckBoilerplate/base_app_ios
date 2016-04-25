//
//  PresentationModule.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Swinject

class PresentationModule {
    
    static func setup(defaultContainer: Container) {
        
        defaultContainer.register(Wireframe.self) { r in Wireframe() }
            .inObjectScope(.Container)
        
        defaultContainer.register(SyncScreens.self) { _ in SyncScreens() }
            .inObjectScope(.Container)
        
        resolvePresenters(defaultContainer)
        resolveViewControllers(defaultContainer)
    }
    
    static func resolveViewControllers(defaultContainer: Container) {
        
        defaultContainer.registerForStoryboard(LaunchViewController.self) { r, c in
            c.presenter = r.resolve(LaunchPresenter.self)!
            c.syncScreens = r.resolve(SyncScreens.self)!
            c.wireframe = r.resolve(Wireframe.self)!
        }
        
        defaultContainer.registerForStoryboard(DashboardViewController.self) { r, c in
            c.presenter = r.resolve(DashboardPresenter.self)!
            c.syncScreens = r.resolve(SyncScreens.self)!
            c.wireframe = r.resolve(Wireframe.self)!
        }
        
        defaultContainer.registerForStoryboard(UsersViewController.self) { r, c in
            c.presenter = r.resolve(UsersPresenter.self)!
            c.syncScreens = r.resolve(SyncScreens.self)!
            c.wireframe = r.resolve(Wireframe.self)!
        }
        
        defaultContainer.registerForStoryboard(UserViewController.self) { r, c in
            c.presenter = r.resolve(UserPresenter.self)!
            c.syncScreens = r.resolve(SyncScreens.self)!
            c.wireframe = r.resolve(Wireframe.self)!
        }
        
        defaultContainer.registerForStoryboard(SearchUserViewController.self) { r, c in
            c.presenter = r.resolve(SearchUserPresenter.self)!
            c.syncScreens = r.resolve(SyncScreens.self)!
            c.wireframe = r.resolve(Wireframe.self)!
        }
    }
    
    static func resolvePresenters(defaultContainer: Container) {
        
        // MARK: - Launch
        defaultContainer.register(LaunchPresenter.self) { r in
            LaunchPresenter(wireframeRepository: r.resolve(WireframeRepository.self)!)
        }
        
        // MARK: - Dashboard
        defaultContainer.register(DashboardPresenter.self) { r in
            DashboardPresenter(wireframeRepository: r.resolve(WireframeRepository.self)!)
        }
        
        // MARK: - Users
        defaultContainer.register(UsersPresenter.self) { r in
            UsersPresenter(wireframeRepository: r.resolve(WireframeRepository.self)!, userRepository: r.resolve(UserRepository.self)!)
        }
        
        // MARK: - User
        defaultContainer.register(UserPresenter.self) { r in
            UserPresenter(wireframeRepository: r.resolve(WireframeRepository.self)!)
        }
        
        // MARK: - Search user
        defaultContainer.register(SearchUserPresenter.self) { r in
            SearchUserPresenter(wireframeRepository: r.resolve(WireframeRepository.self)!, userRepository: r.resolve(UserRepository.self)!)
        }
    }
}
