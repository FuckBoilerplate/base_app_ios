//
//  GcmNotification.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import ObjectMapper

struct GcmNotification<T>: Mappable {
    
    static func getMessageFromGcmNotification(_ message: RxMessage) -> GcmNotification {
        // Ugly casting
        return Mapper().map(JSON: message.getPayload() as NSDictionary as! [String: Any])!
    }
    
    static func getDataFromGcmNofitication(_ message: RxMessage) -> T {
        return getMessageFromGcmNotification(message).data
    }
    
    init?(map: Map) {}
    
    var data: T!
    var title: String!
    var body: String!
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        title <- map["title"]
        body <- map["body"]
    }
}

// Targets are defined here
enum GcmNotificationType: String {
    case None = "none"
}
