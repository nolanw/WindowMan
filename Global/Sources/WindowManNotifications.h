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

// userInfo key for a hotkey preference.
extern NSString * WindowManUserInfoPreferenceKey;

// The Helper app listens for this notification and terminates when notified.
extern NSString * WindowManTerminateHelperAppNotification;

// The Helper app listens for this notification and executes the action for the 
// preference in the note's userInfo.
extern NSString * WindowManPerformActionNotification;

// The Menu app listens for this notification and terminates when notified.
extern NSString * WindowManTerminateMenuAppNotification;
