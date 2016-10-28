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

    func getUserByName(_ username: String) -> Observable<Response>
    func getUsers(_ lastIdQueried: Int?, perPage: Int) -> Observable<Response>
}

// Fixed Moya scheduler issue
extension RxMoyaProvider {
    
    func requestBackground(_ token: Target) -> Observable<Response> {
        return request(token).observeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

extension ObservableType where E == Response {
    
    func mapObjectBackground<T: Mappable>(_ type: T.Type) -> Observable<T> {
        return mapObject(type).observeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func mapArrayBackground<T: Mappable>(_ type: T.Type) -> Observable<[T]> {
        return mapArray(type).observeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
