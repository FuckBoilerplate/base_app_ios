//
//  TokenUpdate.swift
//  RxGcm_swift
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import Foundation

public class TokenUpdate {
    
    private let token: String!

    init(token: String){
        self.token = token
    }
    
    public func getToken() -> String {
        return token
    }
}