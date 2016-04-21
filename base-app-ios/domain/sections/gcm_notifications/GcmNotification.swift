//
//  GcmNotification.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import ObjectMapper

struct GcmNotification<T>: Mappable {
    
    static func getMessageFromGcmNotification(message: RxMessage) -> GcmNotification {
        return Mapper().map(message.getPayload())!
    }
    
    static func getDataFromGcmNofitication(message: RxMessage) -> T {
        return getMessageFromGcmNotification(message).data
    }
    
    init?(_ map: Map) {}
    
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