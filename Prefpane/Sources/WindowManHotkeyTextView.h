//
//  WindowManHotkeyTextView.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-05.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NWHotkeyBox;

@interface WindowManHotkeyTextView : NSTextView
{
  NWHotkeyBox *hotkey;
  BOOL requireAtLeastTwoModifiers;
}

// The boxed hotkey whose string value is currently set.
@property (nonatomic, readonly, retain) NWHotkeyBox *hotkey;
@property (nonatomic, assign) BOOL requireAtLeastTwoModifiers;

@end
