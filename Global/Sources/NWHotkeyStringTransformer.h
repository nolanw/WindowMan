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

extern const NSInteger NWHotkeyControlPadClearKeyCode;
extern const NSInteger NWHotkeyControlNumpadCommaKeyCode;


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
