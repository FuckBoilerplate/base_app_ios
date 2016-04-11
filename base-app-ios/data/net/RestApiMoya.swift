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
    
    func getUser(username: String) -> Observable<Response> {
        return provider.requestBackground(Endpoints.GetUser(username: username))
    }
    
    func getUsers() -> Observable<Response> {
        return provider.requestBackground(Endpoints.GetUsers)
    }
}

// MARK: - Moya Configuration!

// MARK: - Header Api Version
    let HEADER_API_VERSION = "Accept: application/vnd.github.v3+json"

// MARK: - Endpoints
public enum Endpoints {
    case GetUser(username: String)
    case GetUsers
}

extension Endpoints: TargetType {
    
    // MARK: - Endpoint -> Base URL
    public var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
    
    // MARK: - Endpoint -> Path
    public var path: String {
        switch self {
        case .GetUser(let username):
            return "/users/\(username.URLEscapedString)"
        case .GetUsers:
            return "/users"
        }
    }
    
    // MARK: - Endpoint -> Method
    public var method: Moya.Method {
        switch self {
        case .GetUser:
            return .GET
        case .GetUsers:
            return .GET
        }
    }
    
    // : - Endpoint -> Parameters
    public var parameters: [String: AnyObject]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - Endpoint -> Parameters Encoding
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .GetUser:
            return .URL
        case .GetUsers:
            return .URL
        }
    }
    
    // MARK: - Endpoint -> Headers
    public var headers: [String: String] {
        // Default value
        return ["HEADER_API_VERSION": HEADER_API_VERSION]
    }
    
    // MARK: - Endpoint -> Sample Data
    public var sampleData: NSData {
        switch self {
        case .GetUser(let username):
            return "{\"login\": \"\(username)\", \"id\": 100}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .GetUsers:
            return "Half measures are as bad as nothing at all.".dataUsingEncoding(NSUTF8StringEncoding)!
        default:
            return "[{\"name\": \"Repo Name\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

// MARK: - Endpoint Closure
let endpointClosure = { (target: Endpoints) -> Endpoint<Endpoints> in
    let endpoint: Endpoint<Endpoints> = Endpoint<Endpoints>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
    // Sign all non-authenticating requests
    
    // Headers
    return endpoint.endpointByAddingHTTPHeaderFields(target.headers)
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

public extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}
