//
//  UIViewController+RegisterAsGcmReceiversUIForeground.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/7/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    override public class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
         dispatch_once(&Static.token) {
            // Change methods implementations
            changeMethodImplementation(
                "viewWillAppear:",
                rxgcmSelector: "rxgcm_viewWillAppear:"
            )
            changeMethodImplementation(
                "viewWillDisappear:",
                rxgcmSelector: "rxgcm_viewWillDisappear:"
            )
        }
        
    }
    
    class func changeMethodImplementation(originalSelector: String, rxgcmSelector: String) {
        
        let originalSelector = Selector(originalSelector)
        let rxgcmSelector = Selector(rxgcmSelector)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let rxgcmMethod = class_getInstanceMethod(self, rxgcmSelector)
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(rxgcmMethod), method_getTypeEncoding(rxgcmMethod))
        
        if didAddMethod {
            class_replaceMethod(self, rxgcmSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, rxgcmMethod)
        }
        
    }
    
    // MARK: - New Methods Implementations
    
    func rxgcm_viewWillAppear(animated: Bool) {
        self.rxgcm_viewWillAppear(animated)
        GetGcmReceiversUIForeground.presentedViewControllers.append(self)
    }
    
    func rxgcm_viewWillDisappear(animated: Bool) {
        self.rxgcm_viewWillDisappear(animated)
        GetGcmReceiversUIForeground.presentedViewControllers.removeObject(self)
    }
    
}
