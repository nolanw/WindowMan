//
//  WindowManHotkeyCell.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-05.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHotkeyCell.h"
#import "WindowManHotkeyTextView.h"


@implementation WindowManHotkeyCell

// NSCell

- (NSTextView *)fieldEditorForView:(NSView *)aControlView
{
  static WindowManHotkeyTextView *fieldEditor = nil;
  if (fieldEditor == nil)
  {
    fieldEditor = [[WindowManHotkeyTextView alloc] initWithFrame:NSZeroRect];
  }

  return fieldEditor;
}

@end
