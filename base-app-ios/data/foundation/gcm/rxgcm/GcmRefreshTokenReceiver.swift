//
//  GcmRefreshTokenReceiver.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

/**
* The class which implements this interface will receive updates when token is refreshed.
*/
public protocol GcmRefreshTokenReceiver: NSObjectProtocol {
    func onTokenReceive(_ oTokenUpdate: Observable<TokenUpdate>)
}
