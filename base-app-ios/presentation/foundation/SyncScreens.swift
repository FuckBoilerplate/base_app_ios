//
//  SyncScreens.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

class SyncScreens {

    fileprivate var pendingScreens: [String]!
    
    init() {
        pendingScreens = []
    }
    
    func addScreen(_ screen: String) {
        if !pendingScreens.contains(screen) {
            pendingScreens.append(screen)
        }
    }
    
    func needToSync(_ candidate: String) -> Bool {
        var needToSync = false
        
        for screen in pendingScreens {
            if candidate == screen {
                needToSync = true
                break
            }
        }
        
        if needToSync {
            pendingScreens.removeObject(candidate)
        }
        return needToSync
    }
}
