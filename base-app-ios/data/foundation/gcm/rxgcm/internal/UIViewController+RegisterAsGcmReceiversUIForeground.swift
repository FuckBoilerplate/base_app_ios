//
//  UIViewController+RegisterAsGcmReceiversUIForeground.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/7/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    static var once: Void = {
        // Do this once
        // Change methods implementations
        changeMethodImplementation(
            "viewWillAppear:",
            rxgcmSelector: "rxgcm_viewWillAppear:"
        )
        changeMethodImplementation(
            "viewWillDisappear:",
            rxgcmSelector: "rxgcm_viewWillDisappear:"
        )
    }()
    
    override open class func initialize() {
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        print("\(self) + once")
        _ = once
        
    }
    
    class func changeMethodImplementation(_ originalSelector: String, rxgcmSelector: String) {
        
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
    internal func rxgcm_viewWillAppear(_ animated: Bool) {
        self.rxgcm_viewWillAppear(animated)
        if self is GcmReceiverUIForeground {
            GetGcmReceiversUIForeground.presentedViewControllers.append(self)
        }
    }
    
    internal func rxgcm_viewWillDisappear(_ animated: Bool) {
        self.rxgcm_viewWillDisappear(animated)
        if self is GcmReceiverUIForeground {
            GetGcmReceiversUIForeground.presentedViewControllers.removeObject(self)
        }
    }
    
}
