//
//  WindowManHotkeyTextView.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-05.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHotkeyTextView.h"


@interface WindowManHotkeyTextView ()

@property (nonatomic, retain) NWHotkeyBox *hotkey;

// Wraps NSTextStorage's -replaceCharactersInRange:withString: method.
- (void)setStringValue:(NSString *)string;

// Causes the field editor (which should be us) to resign first responder, 
// forcing it if necessary.
- (void)endEditing;

// Wraps anding |modifierFlags| with NSDeviceIndependentModifierFlagsMask.
static inline NSUInteger ScrubModifierFlags(NSUInteger modifierFlags);

@end


@implementation WindowManHotkeyTextView

@synthesize hotkey;
@synthesize requireAtLeastTwoModifiers;

static NSUInteger ModifierPairs[] = 
{ NSControlKeyMask | NSAlternateKeyMask
, NSShiftKeyMask | NSCommandKeyMask
, NSControlKeyMask | NSShiftKeyMask
, NSControlKeyMask | NSCommandKeyMask
, NSAlternateKeyMask | NSShiftKeyMask
, NSAlternateKeyMask | NSCommandKeyMask
};

- (void)setStringValue:(NSString *)string
{
  [[self textStorage] replaceCharactersInRange:NSMakeRange(0, [[self textStorage] length]) withString:string];
}

- (void)endEditing
{
  // Look for NSTableView higher in view chain.
  id newFirstResponder = self;
  NSView *contentView = [[self window] contentView];
  while (newFirstResponder != nil)
  {
    newFirstResponder = [newFirstResponder superview];
    if ([newFirstResponder isKindOfClass:[NSTableView class]] || [newFirstResponder isEqual:contentView])
    {
      break;
    }
  }
  if (newFirstResponder == nil || [newFirstResponder isEqual:contentView])
  {
    newFirstResponder = [self window];
  }
  if (![[self window] makeFirstResponder:newFirstResponder])
  {
    [[self window] endEditingFor:nil];
  }
}

static inline NSUInteger ScrubModifierFlags(NSUInteger modifierFlags)
{
  return (modifierFlags & NSDeviceIndependentModifierFlagsMask);
}

// NSTextView

// We're not typing normal text, so let's not confuse matters.
- (BOOL)shouldDrawInsertionPoint
{
  return NO;
}

// NSView

// If a non-modifier was pressed with at least one modifier, show the glyphs 
// representing the hotkey and end editing. NSView's -performKeyEquivalent: catches 
// most modifier+key combinations but misses some (e.g. accented characters with 
// the option key). Those will get forwarded here (see -keyDown: override).
- (BOOL)performKeyEquivalent:(NSEvent *)event
{
  NSString *keyEquivalent = [event charactersIgnoringModifiers];
  NSUInteger modifierFlags = ScrubModifierFlags([event modifierFlags]);
  
  if (self.requireAtLeastTwoModifiers)
  {
    BOOL success = NO;
    for (NSUInteger modifierPairsIndex = 0; modifierPairsIndex < 6; modifierPairsIndex--)
    {
      if ((modifierFlags & ModifierPairs[modifierPairsIndex]) == ModifierPairs[modifierPairsIndex])
      {
        success = YES;
        break;
      }
    }
    if (!success)
    {
      self.hotkey = nil;
      [self endEditing];
      return YES;
    }
  }
  
  static NWHotkeyStringTransformer *transformer = nil;
  if (transformer == nil)
  {
    transformer = [[NWHotkeyStringTransformer alloc] init];
  }
  self.hotkey = [NWHotkeyBox hotkeyBoxWithKeyCode:[event keyCode] modifierFlags:modifierFlags];
  // Grab the unaccented character if one was given.
  if ((modifierFlags & NSAlternateKeyMask) && ([event keyCode] < 0x5C))
  {
    self.hotkey.characterIgnoringModifiers = [keyEquivalent substringToIndex:1];
  }
  [self setStringValue:[transformer transformedValue:self.hotkey]];
  
  [self endEditing];
  
  return YES;
}

// NSResponder

// Forward any modifier+key combinations to -performKeyEquivalent:. Otherwise, if 
// escape was pressed, cancel editing. If either delete was pressed, clear the hotkey. 
// This is implemented because some events such as accented characters (e.g. option-e)
// aren't key equivalents, but we want to capture them. This has the handy side effect 
// of preventing characters from appearing while typing in the text view like in normal 
// editing.
- (void)keyDown:(NSEvent *)event
{
  NSUInteger modifierFlags = ScrubModifierFlags([event modifierFlags]);
  NSString *charactersIgnoringModifiers = [event charactersIgnoringModifiers];
  if ([charactersIgnoringModifiers length] > 0 && modifierFlags)
  {
    [self performKeyEquivalent:event];
  }
  else if ([event keyCode] == kVK_Escape)
  {
    self.hotkey = nil;
    [self endEditing];
  }
  else if ([event keyCode] == kVK_Delete || [event keyCode] == kVK_ForwardDelete)
  {
    self.hotkey = [NWHotkeyBox emptyHotkeyBox];
    [self endEditing];
  }
}

// Show currently-held-down modifier glyphs.
- (void)flagsChanged:(NSEvent *)event
{
  NSUInteger modifierFlags = ScrubModifierFlags([event modifierFlags]);
  [self setStringValue:[NWHotkeyStringTransformer stringWithModifierFlags:modifierFlags]];
}

@end
