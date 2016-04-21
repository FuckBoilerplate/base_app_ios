//
//  GcmReceiverData.swift
//  RxGcm_swift
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift

/**s
* The class which implements this interface will receive the push notifications
*/
public protocol GcmReceiverData: NSObjectProtocol {
    /**
    * @return return the new instance observable after applying doOn operator.
    */
    func onNotification(oMessage: Observable<RxMessage>) -> Observable<RxMessage>
}