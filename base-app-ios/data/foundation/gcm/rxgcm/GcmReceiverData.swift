//
//  GcmReceiverData.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**s
* The class which implements this interface will receive the push notifications
*/
public protocol GcmReceiverData: NSObjectProtocol {
    /**
    * @return return the new instance observable after applying doOn operator.
    */
    func onNotification(_ oMessage: Observable<RxMessage>) -> Observable<RxMessage>
}
