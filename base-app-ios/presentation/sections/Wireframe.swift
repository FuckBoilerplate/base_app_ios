//
//  Wireframe.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import RxSwift

class Wireframe {
    
    // MARK: - ViewControllers
    
    func dashboard() {
        
        let dashboard = R.storyboard.dashboard.dashboardViewController()!
        
        // Use an empty ViewController, because the dashboard is going to show the good one
        let slideMenuController = SlideMenuController(mainViewController: UIViewController(), leftMenuViewController: dashboard)
        
        UIApplication.topViewController()!.present(slideMenuController, animated: true, completion: nil)
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
            navigationController.popViewController(animated: true)
        } else { // If not, dismiss
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - Private Methods
extension Wireframe {
    
    fileprivate func getViewController<T: UIViewController>(_ storyboardName: String, viewControllerClass t: T.Type) -> T {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        return storyboard.instantiateViewController(withIdentifier: NSStringFromClass(T)) as! T
    }
    
    // MARK: - Present Methods
    fileprivate func presentViewController<T: UIViewController>(_ storyboardName: String, viewControllerClass t: T.Type) {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: NSStringFromClass(T)) as! T
        
        UIApplication.topViewController()!.present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func presentViewController(_ viewController: UIViewController) {
        
        UIApplication.topViewController()!.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Push Methods
    fileprivate func pushViewController<T: UIViewController>(_ storyboardName: String, viewControllerClass t: T.Type) {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: NSStringFromClass(T)) as! T
        
        // Push if there is a Navigation Controller
        if let navigationController = UIApplication.topViewController()!.slideMenuController()?.mainViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else { // If not, Present
            presentViewController(viewController)
        }
    }
    
    fileprivate func pushViewController(_ viewController: UIViewController) {
        
        // Push if there is a Navigation Controller
        if let navigationController = UIApplication.topViewController()!.slideMenuController()?.mainViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else if let navigationController = UIApplication.topViewController()?.parent as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else { // If not, Present
            presentViewController(viewController)
        }
    }
}
