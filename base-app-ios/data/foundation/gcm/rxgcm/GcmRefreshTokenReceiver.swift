//
//  GcmRefreshTokenReceiver.swift
//  RxGcm_swift
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift

/**
* The class which implements this interface will receive updates when token is refreshed.
*/
public protocol GcmRefreshTokenReceiver: NSObjectProtocol {
    func onTokenReceive(oTokenUpdate: Observable<TokenUpdate>)
}