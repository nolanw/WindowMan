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

- (void)dealloc
{
  [fieldEditor release];
  
  [super dealloc];
}

// NSCell

- (NSTextView *)fieldEditorForView:(NSView *)aControlView
{
  if (fieldEditor == nil)
  {
    fieldEditor = [[WindowManHotkeyTextView alloc] init];
    [fieldEditor setFieldEditor:YES];
  }
  
  return fieldEditor;
}

@end
