//
//  WindowManHotkeyCell.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-05.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowManHotkeyTextView;


// All this subclass does is provide a custom field editor for hotkeys.
@interface WindowManHotkeyCell : NSTextFieldCell
{
  WindowManHotkeyTextView *fieldEditor;
}

@property (readonly) WindowManHotkeyTextView *fieldEditor;

@end
