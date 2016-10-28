//
//  SyncScreens.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/22/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

protocol SyncScreensMatcher {
    func matchesTarget(_ key: String) -> Bool
}

class SyncScreens {
    
    private var pendingScreens: [String]!
    
    init() {
        pendingScreens = []
    }
    
    func addScreen(screen: String) {
        if !pendingScreens.contains(screen) {
            pendingScreens.append(screen)
        }
    }
    
    func needToSync(matcher: SyncScreensMatcher) -> Bool {
        var needToSync = false
        
        var index = 0
        
        for i in 0..<pendingScreens.count {
            if matcher.matchesTarget(pendingScreens[i]) {
                needToSync = true
                index = i
                break
            }
        }
        
        if needToSync {
            pendingScreens.removeObject(index)
        }
        return needToSync
    }
    
}
