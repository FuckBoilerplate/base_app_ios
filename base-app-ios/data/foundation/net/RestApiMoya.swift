//
//  RestApiMoya.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper
import ObjectMapper

class RestApiMoya: RestApi {
    
    // MARK: - Provider setup
    let provider = RxMoyaProvider<MoyaEndpoints>(endpointClosure: endpointClosure)
    
    func getUserByName(_ username: String) -> Observable<Response> {
        return provider.requestBackground(MoyaEndpoints.getUser(username: username))
    }
    
    func getUsers(_ lastIdQueried: Int?, perPage: Int) -> Observable<Response> {
        return provider.requestBackground(MoyaEndpoints.getUsers(lastIdQueried: lastIdQueried, perPage: perPage))
    }
}
