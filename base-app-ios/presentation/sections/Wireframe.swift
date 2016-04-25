//
//  Wireframe.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import Swinject
import RxSwift

class Wireframe {
    
    // MARK: - ViewControllers
    
    func dashboard() {
        
        let dashboard = R.storyboard.dashboard.dashboardViewController()!
        
        // Use an empty ViewController, because the dashboard is going to show the good one
        let slideMenuController = SlideMenuController(mainViewController: UIViewController(), leftMenuViewController: dashboard)
        
        UIApplication.topViewController()!.presentViewController(slideMenuController, animated: true, completion: nil)
    }
    
    func searchUserScreen() {
        pushViewController(R.storyboard.user.searchUserViewController()!)
    }
    
    func userScreen() {
        pushViewController(R.storyboard.user.userViewController()!)
    }
    
    func usersScreen() {
        pushViewController(R.storyboard.user.usersViewController()!)
    }
    
    func popCurrentScreen() {
        // Pop if there is a Navigation Controller
        if let navigationController = UIApplication.topViewController()! as? UINavigationController {
            navigationController.popViewControllerAnimated(true)
        } else { // If not, dismiss
            UIApplication.topViewController()?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

// MARK: - Private Methods
extension Wireframe {
    
    private func getViewController<T: UIViewController>(storyboardName: String, viewControllerClass t: T.Type) -> T {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        return storyboard.instantiateViewControllerWithIdentifier(String(T)) as! T
    }
    
    // MARK: - Present Methods
    private func presentViewController<T: UIViewController>(storyboardName: String, viewControllerClass t: T.Type) {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(String(T)) as! T
        
        UIApplication.topViewController()!.presentViewController(viewController, animated: true, completion: nil)
    }
    
    private func presentViewController(viewController: UIViewController) {
        
        UIApplication.topViewController()!.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Push Methods
    private func pushViewController<T: UIViewController>(storyboardName: String, viewControllerClass t: T.Type) {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(String(T)) as! T
        
        // Push if there is a Navigation Controller
        if let navigationController = UIApplication.topViewController()!.slideMenuController()?.mainViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else { // If not, Present
            presentViewController(viewController)
        }
    }
    
    private func pushViewController(viewController: UIViewController) {
        
        // Push if there is a Navigation Controller
        if let navigationController = UIApplication.topViewController()!.slideMenuController()?.mainViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else if let navigationController = UIApplication.topViewController()?.parentViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else { // If not, Present
            presentViewController(viewController)
        }
    }
}