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
        
        defaultContainer.register(Wireframe.self) { r in Wireframe(wireframeRepository: r.resolve(WireframeRepository.self)!) }
        
        resolvePresenters(defaultContainer)
        resolveViewControllers(defaultContainer)
    }
    
    static func resolveViewControllers(defaultContainer: Container) {
        
        defaultContainer.registerForStoryboard(LaunchViewController.self) { r, c in
            c.presenter = r.resolve(LaunchPresenter.self)!
        }
        
        defaultContainer.registerForStoryboard(DashboardViewController.self) { r, c in
            c.presenter = r.resolve(DashboardPresenter.self)!
        }
        
        defaultContainer.registerForStoryboard(UsersViewController.self) { r, c in
            c.presenter = r.resolve(UsersPresenter.self)!
        }

        defaultContainer.registerForStoryboard(UserViewController.self) { r, c in
            c.presenter = r.resolve(UserPresenter.self)!
        }
        
        defaultContainer.registerForStoryboard(SearchUserViewController.self) { r, c in
            c.presenter = r.resolve(SearchUserPresenter.self)!
        }
    }
    
    static func resolvePresenters(defaultContainer: Container) {
        
        // MARK: - Launch
        defaultContainer.register(LaunchPresenter.self) { r in
            LaunchPresenter(wireframe: r.resolve(Wireframe.self)!)
        }

        // MARK: - Dashboard
        defaultContainer.register(DashboardPresenter.self) { r in
            DashboardPresenter(wireframe: r.resolve(Wireframe.self)!)
        }
        
        // MARK: - Users
        defaultContainer.register(UsersPresenter.self) { r in
            UsersPresenter(wireframe: r.resolve(Wireframe.self)!, userRepository: r.resolve(UserRepository.self)!)
        }
        
        // MARK: - User
        defaultContainer.register(UserPresenter.self) { r in
            UserPresenter(wireframe: r.resolve(Wireframe.self)!)
        }
        
        // MARK: - Search user
        defaultContainer.register(SearchUserPresenter.self) { r in
            SearchUserPresenter(wireframe: r.resolve(Wireframe.self)!, userRepository: r.resolve(UserRepository.self)!)
        }
    }
}
