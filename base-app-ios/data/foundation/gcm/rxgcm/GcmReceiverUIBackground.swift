//
//  GcmReceiverUIBackground.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**
* The class which implements this interface will receive the push notifications when the application is onBackground state
* just after GcmReceiverData has completed its task.
* @see GcmReceiverData
*/
public protocol GcmReceiverUIBackground: NSObjectProtocol {
    func onNotification(_ oMessage: Observable<RxMessage>)
}
