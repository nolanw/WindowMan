//
//  WindowManNotifications.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-06.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

// Sent when a hotkey setting changes. Note's userInfo contains the preference key 
// where the new hotkey is stored.
extern NSString * WindowManHotkeyPreferencesDidChangeNotification;

// userInfo key for PreferencesDidChangeNotification for new hotkey preference.
extern NSString * WindowManChangedPreferenceKey;

// The Helper app listens for this notification and terminates when notified.
extern NSString * WindowManTerminateHelperAppNotification;