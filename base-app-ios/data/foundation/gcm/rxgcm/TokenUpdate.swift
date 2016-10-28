//
//  TokenUpdate.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

open class TokenUpdate {
    
    fileprivate let token: String!
    
    init(token: String){
        self.token = token
    }
    
    open func getToken() -> String {
        return token
    }
}
