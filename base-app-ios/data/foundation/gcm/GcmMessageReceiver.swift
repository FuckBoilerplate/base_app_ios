//
//  GcmMessageReceiver.swift
//  base-app-ios
//
//  Created by Roberto Frontado on 4/21/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class GcmMessageReceiver: NSObject, GcmReceiverData {
    
    func onNotification(oMessage: Observable<RxMessage>) -> Observable<RxMessage> {
        return oMessage
    }
}
