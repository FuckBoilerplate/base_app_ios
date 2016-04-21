//
//  Constants.swift
//  Example
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

class Constants {
    static let KEY_USER_DEFAULTS_TOKEN = "key_shared_preferences_token"
    static let KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER = "key_shared_class_name_gcm_receiver"
    static let KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER_UI_BACKGROUND = "key_shared_preferences_class_name_gcm_receiver_ui_background"
    static let KEY_USER_DEFAULTS_CLASS_NAME_GCM_REFRESH_TOKEN = "key_shared_class_name_gcm_refresh_token"
    static let ERROR_NOT_CACHED_TOKEN_AVAILABLE = "There is no token. Have you called 'RxGcm.Notifications.register()' before requesting the token"
    static let GOOGLE_PLAY_SERVICES_ERROR = "A token has been requested but Google play services is not available"
    static let NOT_RECEIVER_FOR_FOREGROUND_UI_NOTIFICATIONS = "A notification on foreground has been received, but it has not been supplied a class which implements GcmReceiverUIForeground"
    static let NOT_RECEIVER_FOR_REFRESH_TOKEN = "Token has been refresh but it has not been supplied a class which implements GcmRefreshTokenReceiver"
    static let ERROR_NOT_PUBLIC_EMPTY_CONSTRUCTOR_FOR_CLASS = "The class which you have supplied implementing $$$ can have only one public empty constructor"
    static let ERROR_GCM_NOT_AVAILABLE = "GCM is not available"
    static let ERROR_TOKEN_IS_MISSING = "GCM Token is missing"
}
