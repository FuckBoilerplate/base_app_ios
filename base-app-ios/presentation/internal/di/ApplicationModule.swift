//
//  ApplicationModule.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Swinject

extension SwinjectStoryboard {
    
    class func setup() {
        
        DataModule.setup(defaultContainer)
        DomainModule.setup(defaultContainer)
        PresentationModule.setup(defaultContainer)
    }
}