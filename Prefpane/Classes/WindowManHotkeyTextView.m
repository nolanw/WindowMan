//
//  WindowManHotkeyTextView.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-05.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHotkeyTextView.h"


@interface WindowManHotkeyTextView ()

// Wraps NSTextStorage's -replaceCharactersInRange:withString: method.
- (void)setStringValue:(NSString *)string;

// Causes the field editor (which should be us) to resign first responder, 
// forcing it if necessary.
- (void)endEditing;

@end


@implementation WindowManHotkeyTextView

- (void)setStringValue:(NSString *)string
{
  [[self textStorage] replaceCharactersInRange:NSMakeRange(0, [[self textStorage] length]) withString:string];
}

- (void)endEditing
{
  if (![[self window] makeFirstResponder:[self window]])
  {
    [[self window] endEditingFor:nil];
  }
}

// NSTextView

- (BOOL)shouldDrawInsertionPoint
{
  return NO;
}

// NSView

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  NSString *keyEquivalent = [event charactersIgnoringModifiers];
  NSUInteger modifierFlags = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
  
  if ([keyEquivalent length] == 0)
  {
    [self setStringValue:[NWHotkeyStringTransformer stringWithModifierFlags:modifierFlags]];
    return YES;
  }
  
  static NWHotkeyStringTransformer *transformer = nil;
  if (transformer == nil)
  {
    transformer = [[NWHotkeyStringTransformer alloc] init];
  }
  NWHotkeyBox *hotkeyBox = [NWHotkeyBox hotkeyBoxWithKeyCode:[event keyCode] modifierFlags:modifierFlags];
  hotkeyBox.characterIgnoringModifiers = [keyEquivalent substringToIndex:1];
  [self setStringValue:[transformer transformedValue:hotkeyBox]];
  
  [self endEditing];
  
  return YES;
}

// NSResponder

- (void)keyDown:(NSEvent *)event
{
  NSLog(@"%s event: %@", _cmd, event);
  if ([[event charactersIgnoringModifiers] length] > 0)
  {
    [self performKeyEquivalent:event];
  }
  else
  {
    [self setStringValue:[NWHotkeyStringTransformer stringWithModifierFlags:[event modifierFlags]]];
  }
}

@end
