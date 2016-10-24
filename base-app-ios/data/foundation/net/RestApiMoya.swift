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
    let provider = RxMoyaProvider<Endpoints>(endpointClosure: endpointClosure)
    
    func getUserByName(_ username: String) -> Observable<Response> {
        return provider.requestBackground(Endpoints.getUser(username: username))
    }
    
    func getUsers(_ lastIdQueried: Int?, perPage: Int) -> Observable<Response> {
        return provider.requestBackground(Endpoints.getUsers(lastIdQueried: lastIdQueried, perPage: perPage))
    }
}

// MARK: - Moya Configuration!

// MARK: - Header Api Version
    let HEADER_API_VERSION = "Accept: application/vnd.github.v3+json"

// MARK: - Endpoints
public enum Endpoints {
    case getUser(username: String)
    case getUsers(lastIdQueried: Int?, perPage: Int)
}

extension Endpoints: TargetType {
    
    public var task: Task {
        return Task.request
    }

    
    // MARK: - Endpoint -> Base URL
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    // MARK: - Endpoint -> Path
    public var path: String {
        switch self {
        case .getUser(let username):
            return "/users/\(username.URLEscapedString)"
        case .getUsers:
            return "/users"
        }
    }
    
    // MARK: - Endpoint -> Method
    public var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .getUsers:
            return .get
        }
    }
    
    // : - Endpoint -> Parameters
    public var parameters: [String: Any]? {
        switch self {
        case.getUsers(let lastIdQueried, let perPage):
            var values = ["per_page": perPage]
            if let lastIdQueried = lastIdQueried {
                 values.updateValue(lastIdQueried, forKey: "since")
            }
            return values as [String : AnyObject]?
        default:
            return nil
        }
    }
    
    // MARK: - Endpoint -> Parameters Encoding
//    public var parameterEncoding: Moya.ParameterEncoding {
//        switch self {
//        case .getUser:
//            return
//        case .getUsers:
//            return .url
//        }
//    }
    
    // MARK: - Endpoint -> Headers
    public var headers: [String: String] {
        // Default value
        return ["HEADER_API_VERSION": HEADER_API_VERSION]
    }
    
    // MARK: - Endpoint -> Sample Data
    public var sampleData: Data {
        switch self {
        case .getUser(let username):
            return "{\"login\": \"\(username)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .getUsers:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        default:
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        }
    }
}

// MARK: - Endpoint Closure
let endpointClosure = { (target: Endpoints) -> Endpoint<Endpoints> in
    let endpoint: Endpoint<Endpoints> = Endpoint<Endpoints>(URL: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    // Sign all non-authenticating requests
    
    // Headers
    return endpoint.adding(newHttpHeaderFields: target.headers)
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.absoluteString + route.path
//    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

public extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
