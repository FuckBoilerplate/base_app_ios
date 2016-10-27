//
//  GcmReceiverUIForeground.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
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
    func onTargetNotification(_ oMessage: Observable<RxMessage>)
    
    /**
     * Called when ViewController does not match with the desired target specified in the bundle notification.
     * @see GcmReceiverUIForeground
     */
    func onMismatchTargetNotification(_ oMessage: Observable<RxMessage>)
    
    /**
     * Determines if the implementing class is interested on be notified when updating the data model or seeking for the activity/fragment to be notified.
     * @param key The value provided in the bundle notification by the server
     * @return true if the implementing class is interested on be notified
     
     */
    func matchesTarget(_ key: String) -> Bool
}
