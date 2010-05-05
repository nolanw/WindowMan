//
//  WindowManHotkeyPreferences.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHotkeyPreferences.h"

NSString * const WindowManHotkeyPreferenceLeftHalf = @"WindowManHotkeyPreferenceLeftHalf";
NSString * const WindowManHotkeyPreferenceRightHalf = @"WindowManHotkeyPreferenceRightHalf";

NSString * const WindowManHotkeyPreferenceTopLeftQuarter = @"WindowManHotkeyPreferenceTopLeftQuarter";
NSString * const WindowManHotkeyPreferenceTopRightQuarter = @"WindowManHotkeyPreferenceTopRightQuarter";
NSString * const WindowManHotkeyPreferenceBottomRightQuarter = @"WindowManHotkeyPreferenceBottomRightQuarter";
NSString * const WindowManHotkeyPreferenceBottomLeftQuarter = @"WindowManHotkeyPreferenceBottomLeftQuarter";

NSString * const WindowManHotkeyPreferenceCenter = @"WindowManHotkeyPreferenceCenter";
NSString * const WindowManHotkeyPreferenceMaximize = @"WindowManHotkeyPreferenceMaximize";

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
    
    , WindowManHotkeyPreferenceCenter
    , WindowManHotkeyPreferenceMaximize
    , nil];
  }
  return WindowManHotkeyPreferencesArray;
}
