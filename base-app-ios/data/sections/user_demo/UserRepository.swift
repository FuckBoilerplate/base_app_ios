//
//  UserRepository.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 2/18/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift
import ObjectMapper
import RxCache

class UserRepository: Repository {
    
    static let FIRST_ID_QUERIED = 0
    static let USERS_PER_PAGE = 50
    static let MAX_USERS_TO_LOAD = 300
    
    override init(restApi: RestApi, rxProviders: RxCache) {
        super.init(restApi: restApi, rxProviders: rxProviders)
    }
    
    func searchByUserName(nameUser: String) -> Observable<User> {
        return restApi.getUserByName(nameUser)
            .flatMap { (response) -> Observable<User> in
            
                if let error: Observable<User> = self.handleError(response) {
                    return error
                }
                
                do {
                    let responseUser: User = try response.mapObject()
                    return Observable.just(responseUser)
                } catch {
                    return self.buildObservableError("Error mapping the response")
                }
        }
    }
    
    func getUsers(lastIdQueried: Int?, refresh: Bool) -> Observable<[User]> {
        var oLoader = restApi.getUsers(lastIdQueried, perPage: UserRepository.USERS_PER_PAGE)
            .flatMap { (response) -> Observable<[User]> in
                
                if let error: Observable<[User]> = self.handleError(response) {
                    return error
                }
                
                do {
                    let responseUser: [User] = try response.mapArray()
                    return Observable.just(responseUser)
                } catch {
                    return self.buildObservableError("Error mapping the response")
                }
        }
        
        if lastIdQueried == UserRepository.FIRST_ID_QUERIED {
            let provider = RxCacheProviders.GetUsers(evict: refresh)
            oLoader = rxProviders.cache(oLoader, provider: provider)
        }
        
        return oLoader
    }

}