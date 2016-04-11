//
//  RestApi.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

protocol RestApi {

    func getUser(username: String) -> Observable<Response>
    func getUsers() -> Observable<Response>
}

// Fixed Moya scheduler issue
extension RxMoyaProvider {
    
    func requestBackground(token: Target) -> Observable<Response> {
        return request(token).observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
    }
}

extension ObservableType where E == Response {
    
    func mapObjectBackground<T: Mappable>(type: T.Type) -> Observable<T> {
        return mapObject(type).observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
    }
    
    func mapArrayBackground<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return mapArray(type).observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
    }
}
