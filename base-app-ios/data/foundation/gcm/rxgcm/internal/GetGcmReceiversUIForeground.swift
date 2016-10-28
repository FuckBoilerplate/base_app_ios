//
//  GetGcmReceiversUIForeground.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation
import RxSwift

class GetGcmReceiversUIForeground {
    
    static var presentedViewControllers = [UIViewController]()
    
    func retrieve(_ screenName: String) -> (gcmReceiverUIForeground: GcmReceiverUIForeground, targetScreen: Bool)? {
        
        var receiverCandidate: (gcmReceiverUIForeground: GcmReceiverUIForeground, targetScreen: Bool)? = nil
    
        for viewController in GetGcmReceiversUIForeground.presentedViewControllers {
            
            if let gcmReceiverUIForeground = viewController as? GcmReceiverUIForeground {
                
                let targetScreen = gcmReceiverUIForeground.matchesTarget(screenName)
                receiverCandidate = (gcmReceiverUIForeground: gcmReceiverUIForeground, targetScreen: targetScreen)
                
                if targetScreen {
                    return receiverCandidate
                }
            }
        }
        
        return receiverCandidate
    }
}
