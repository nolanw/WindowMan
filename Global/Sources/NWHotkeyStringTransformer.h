//
//  HotkeyStringTransformer.h
//  HotkeyControl
//
//  Created by Nolan Waite on 10-05-03.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#ifndef NWHOTKEY_STRING_TRANSFORMER_H
#define NWHOTKEY_STRING_TRANSFORMER_H

#import <Cocoa/Cocoa.h>

// Special key codes.

extern const NSInteger NWHotkeyControlF1KeyCode;
extern const NSInteger NWHotkeyControlF2KeyCode;
extern const NSInteger NWHotkeyControlF3KeyCode;
extern const NSInteger NWHotkeyControlF4KeyCode;
extern const NSInteger NWHotkeyControlF5KeyCode;
extern const NSInteger NWHotkeyControlF6KeyCode;
extern const NSInteger NWHotkeyControlF7KeyCode;
extern const NSInteger NWHotkeyControlF8KeyCode;
extern const NSInteger NWHotkeyControlF9KeyCode;
extern const NSInteger NWHotkeyControlF10KeyCode;
extern const NSInteger NWHotkeyControlF11KeyCode;
extern const NSInteger NWHotkeyControlF12KeyCode;
extern const NSInteger NWHotkeyControlF13KeyCode;
extern const NSInteger NWHotkeyControlF14KeyCode;
extern const NSInteger NWHotkeyControlF15KeyCode;
extern const NSInteger NWHotkeyControlF16KeyCode;
extern const NSInteger NWHotkeyControlF17KeyCode;
extern const NSInteger NWHotkeyControlF18KeyCode;
extern const NSInteger NWHotkeyControlF19KeyCode;
extern const NSInteger NWHotkeyControlSpaceKeyCode;
extern const NSInteger NWHotkeyControlDeleteLeftKeyCode;
extern const NSInteger NWHotkeyControlDeleteRightKeyCode;
extern const NSInteger NWHotkeyControlPadClearKeyCode;
extern const NSInteger NWHotkeyControlLeftArrowKeyCode;
extern const NSInteger NWHotkeyControlRightArrowKeyCode;
extern const NSInteger NWHotkeyControlUpArrowKeyCode;
extern const NSInteger NWHotkeyControlDownArrowKeyCode;
extern const NSInteger NWHotkeyControlSoutheastArrowKeyCode;
extern const NSInteger NWHotkeyControlNorthwestArrowKeyCode;
extern const NSInteger NWHotkeyControlEscapeKeyCode;
extern const NSInteger NWHotkeyControlPageDownKeyCode;
extern const NSInteger NWHotkeyControlPageUpKeyCode;
extern const NSInteger NWHotkeyControlReturnR2LKeyCode;
extern const NSInteger NWHotkeyControlReturnKeyCode;
extern const NSInteger NWHotkeyControlTabRightKeyCode;
extern const NSInteger NWHotkeyControlHelpKeyCode;
extern const NSInteger NWHotkeyControlNumpadCommaKeyCode;
extern const NSInteger NWHotkeyControlNumpadAsteriskKeyCode;
extern const NSInteger NWHotkeyControlNumpadPlusKeyCode;
extern const NSInteger NWHotkeyControlNumpadSlashKeyCode;
extern const NSInteger NWHotkeyControlNumpadHyphenKeyCode;
extern const NSInteger NWHotkeyControlNumpadEqualsKeyCode;
extern const NSInteger NWHotkeyControlNumpadZeroKeyCode;
extern const NSInteger NWHotkeyControlNumpadOneKeyCode;
extern const NSInteger NWHotkeyControlNumpadTwoKeyCode;
extern const NSInteger NWHotkeyControlNumpadThreeKeyCode;
extern const NSInteger NWHotkeyControlNumpadFourKeyCode;
extern const NSInteger NWHotkeyControlNumpadFiveKeyCode;
extern const NSInteger NWHotkeyControlNumpadSixKeyCode;
extern const NSInteger NWHotkeyControlNumpadSevenKeyCode;
extern const NSInteger NWHotkeyControlNumpadEightKeyCode;
extern const NSInteger NWHotkeyControlNumpadNineKeyCode;


// Unicode Code Points for glyphs for key codes.

extern const NSInteger NWHotkeyControlDeleteLeftCodePoint;
extern const NSInteger NWHotkeyControlDeleteRightCodePoint;
extern const NSInteger NWHotkeyControlPadClearCodePoint;
extern const NSInteger NWHotkeyControlLeftArrowCodePoint;
extern const NSInteger NWHotkeyControlRightArrowCodePoint;
extern const NSInteger NWHotkeyControlUpArrowCodePoint;
extern const NSInteger NWHotkeyControlDownArrowCodePoint;
extern const NSInteger NWHotkeyControlSoutheastArrowCodePoint;
extern const NSInteger NWHotkeyControlNorthwestArrowCodePoint;
extern const NSInteger NWHotkeyControlEscapeCodePoint;
extern const NSInteger NWHotkeyControlPageDownCodePoint;
extern const NSInteger NWHotkeyControlPageUpCodePoint;
extern const NSInteger NWHotkeyControlReturnR2LCodePoint;
extern const NSInteger NWHotkeyControlReturnCodePoint;
extern const NSInteger NWHotkeyControlTabRightCodePoint;
extern const NSInteger NWHotkeyControlHelpCodePoint;


// HotkeyStringTransformer takes a HotkeyBox as input and outputs an 
// NSString with nice glyphs for modifier keys and special keys.
// 
// Localizable strings (place in table called HotkeyString in this bundle):
//  - @"Space" is the name for the spacebar.
//  - @"NumPad %@" is used when a numpad key is set (the %@ is replaced 
//    with the symbol on the key that is set).
@interface NWHotkeyStringTransformer : NSValueTransformer
{
  
}

// Returns a string representing the modifierFlags masks with appropriate glyphs.
+ (NSString *)stringWithModifierFlags:(NSUInteger)modifierFlags;

// Returns a string representing the keyCode for the current keyboard.
// pre: keyCode is >= 0.
+ (NSString *)stringWithKeyCode:(NSInteger)keyCode;

// -transformedValue: uses the above two methods.

@end

#endif /* ndef NWHOTKEY_STRING_TRANSFORMER_H */
