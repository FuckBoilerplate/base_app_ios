//
//  Repository.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/11/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper
import ObjectMapper
import RxCache

class Repository {

    internal let restApi: RestApi
    internal let rxProviders: RxCache
    
    init(restApi: RestApi, rxProviders: RxCache) {
        self.restApi = restApi
        self.rxProviders = rxProviders
    }
    
    internal func handleError<T>(response: Response) -> Observable<T>? {
        
        do {
            try response.filterSuccessfulStatusCodes()
            return nil
        } catch {
            do {
                let responseString: ResponseError
                responseString = try response.mapObject()
                return Observable.error(NSError(domain: responseString.message, code: 0, userInfo: nil))
            } catch {
                
            }
            return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    private class ResponseError: Mappable {
        var message: String = ""
        
        required init?(_ map: Map) {}
        
        func mapping(map: Map) {
            message <- map["message"]
        }

    }
    
    func buildObservableError<T>(message: String) -> Observable<T> {
        return Observable.error(NSError(domain: message, code: 0, userInfo: nil))
    }
}
