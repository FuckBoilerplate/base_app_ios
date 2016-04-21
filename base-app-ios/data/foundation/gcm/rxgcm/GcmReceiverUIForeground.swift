//
//  GcmReceiverUIForeground.swift
//  RxGcm_swift
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift

/**
 * The ViewController which implement this interface will receive the push notifications when the application is onForeground state
 * just after GcmReceiverData has completed its task.
 * @see GcmReceiverData
 */

public protocol GcmReceiverUIForeground {
    /**
    * Called when ViewController matches with the desired target specified in the bundle notification.
    * @see GcmReceiverUIForeground
    */
    func onTargetNotification(oMessage: Observable<RxMessage>)
    
    /**
    * Called when ViewController does not match with the desired target specified in the bundle notification.
    * @see GcmReceiverUIForeground
    */
    func onMismatchTargetNotification(oMessage: Observable<RxMessage>)
    
    /**
    * @return The value provided in the bundle notification by the server to be used as a filter when updating data model or seeking for the activity/fragment to be notified.
    */
    func target() -> String
}