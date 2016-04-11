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

    override init(restApi: RestApi, rxProviders: RxCache) {
        super.init(restApi: restApi, rxProviders: rxProviders)
    }
    
    func searchByUserName(nameUser: String) -> Observable<User> {
        return restApi.getUser(nameUser)
            .flatMap { (response) -> Observable<User> in
            
                if let error: Observable<User> = self.handleError(response) {
                    return error
                }
                
                do {
                    let responseUser: User = try response.mapObject()
                    return Observable.just(responseUser)
                } catch {
                    return self.buildObservableError("")
                }
        }
    }
    
    func askForUsers() -> Observable<[User]> {
        return restApi.getUsers()
            .flatMap { (response) -> Observable<[User]> in
                
                if let error: Observable<[User]> = self.handleError(response) {
                    return error
                }
                
                do {
                    let responseUser: [User] = try response.mapArray()
                    return Observable.just(responseUser)
                } catch {
                    return self.buildObservableError("")
                }
        }
    }
    
    func getSelectedUserDemoList() -> Observable<User> {
        let provider = RxCacheProviders.GetSelectedUserDemoList(evict: false)
        return rxProviders.cache(RxCache.errorObservable(User.self), provider: provider)
    }
    
    func saveSelectedUserDemoList(user: User) -> Observable<Bool> {
        let provider = RxCacheProviders.GetSelectedUserDemoList(evict: true)
        return rxProviders.cache(Observable.just(user), provider: provider)
            .map { user in true }
    }

}