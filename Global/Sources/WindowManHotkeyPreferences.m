//
//  WindowManHotkeyPreferences.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHotkeyPreferences.h"

NSString * WindowManHotkeyPreferenceLeftHalf = @"WindowManHotkeyPreferenceLeftHalf";
NSString * WindowManHotkeyPreferenceRightHalf = @"WindowManHotkeyPreferenceRightHalf";

NSString * WindowManHotkeyPreferenceTopLeftQuarter = @"WindowManHotkeyPreferenceTopLeftQuarter";
NSString * WindowManHotkeyPreferenceTopRightQuarter = @"WindowManHotkeyPreferenceTopRightQuarter";
NSString * WindowManHotkeyPreferenceBottomRightQuarter = @"WindowManHotkeyPreferenceBottomRightQuarter";
NSString * WindowManHotkeyPreferenceBottomLeftQuarter = @"WindowManHotkeyPreferenceBottomLeftQuarter";

NSString * WindowManHotkeyPreferenceCenterHorizontally = @"WindowManHotkeyPreferenceCenterHorizontally";
NSString * WindowManHotkeyPreferenceCenterAbsolutely = @"WindowManHotkeyPreferenceCenterAbsolutely";

NSString * WindowManHotkeyPreferenceMaximize = @"WindowManHotkeyPreferenceMaximize";

NSArray * WindowManHotkeyPreferences()
{
  static NSArray *WindowManHotkeyPreferencesArray = nil;
  if (WindowManHotkeyPreferencesArray == nil) 
  {
    WindowManHotkeyPreferencesArray = [[NSArray alloc] initWithObjects:WindowManHotkeyPreferenceLeftHalf
    , WindowManHotkeyPreferenceRightHalf
    
    , WindowManHotkeyPreferenceTopLeftQuarter
    , WindowManHotkeyPreferenceTopRightQuarter
    , WindowManHotkeyPreferenceBottomRightQuarter
    , WindowManHotkeyPreferenceBottomLeftQuarter 
    
    , WindowManHotkeyPreferenceCenterHorizontally
    , WindowManHotkeyPreferenceCenterAbsolutely
    
    , WindowManHotkeyPreferenceMaximize
    , nil];
  }
  return WindowManHotkeyPreferencesArray;
}
