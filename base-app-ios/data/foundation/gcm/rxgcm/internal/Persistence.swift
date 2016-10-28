//
//  Persistence.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class Persistence {
    
    func saveClassNameGcmReceiverAndGcmReceiverUIBackground(_ gcmReceiverClassName: String, gcmReceiverUIBackgroundClassName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(gcmReceiverClassName, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER)
        userDefaults.setValue(gcmReceiverUIBackgroundClassName, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER_UI_BACKGROUND)
        userDefaults.synchronize()
    }
    
    func getClassNameGcmReceiver() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER)
    }
    
    func getClassNameGcmReceiverUIBackground() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER_UI_BACKGROUND)
    }
    
    func saveClassNameGcmRefreshTokenReceiver(_ name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(name, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_REFRESH_TOKEN)
        userDefaults.synchronize()
    }
    
    func getClassNameGcmRefreshTokenReceiver() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_REFRESH_TOKEN)
    }
    
    func saveToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token, forKey: Constants.KEY_USER_DEFAULTS_TOKEN)
        userDefaults.synchronize()
    }
    
    func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: Constants.KEY_USER_DEFAULTS_TOKEN)
    }
    
}
