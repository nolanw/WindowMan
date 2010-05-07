//
//  NWHotkeyBox.h
//  HotkeyControl
//
//  Created by Nolan Waite on 10-05-03.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Setting the keyCode to this value represents an unset hotkey.
extern const NSInteger NWHotkeyBoxEmpty;

// Convert Carbon modifier flags to Cocoa modifier flags. Lifted from ShortcutRecorder.
extern NSUInteger SRCarbonToCocoaFlags(NSUInteger carbonFlags);

// Convert Cocoa modifier flags to Carbon modifier flags. Lifted from ShortcutRecorder.
extern NSUInteger SRCocoaToCarbonFlags(NSUInteger cocoaFlags);

// HotkeyBox is a small wrapper around a hotkey, which is a pairing of a keycode 
// (the weird hardware-agnostic code that uniquely identifies a keyboard key) and modifier 
// flags (i.e. function, control, option, command). It's key-value observable and 
// Carbon/Cocoa-agnostic for the modifier flags.
@interface NWHotkeyBox : NSObject <NSCopying>
{
  NSInteger keyCode;
  NSUInteger modifierFlags;
  NSString *characterIgnoringModifiers;
}

@property (nonatomic, assign) NSInteger keyCode;
@property (nonatomic, assign) NSUInteger modifierFlags;
@property (nonatomic, assign) NSUInteger carbonModifierFlags;
@property (nonatomic, retain) NSString *characterIgnoringModifiers;

// Returns an autoreleased instance of HotkeyBox using designated initializer.
+ (id)hotkeyBoxWithKeyCode:(NSInteger)aKeyCode modifierFlags:(NSUInteger)someModifierFlags;

// Designated initializer.
- (id)initWithKeyCode:(NSInteger)aKeyCode modifierFlags:(NSUInteger)someModifierFlags;

// Wraps designated initializer, converting modifier flags to Cocoa flags first.
- (id)initWithKeyCode:(NSInteger)aKeyCode carbonModifierFlags:(NSUInteger)someCarbonModifierFlags;

// Creates an autoreleased instance of HotkeyBox from |preferencesRepresentation|.
// If |preferencesRepresentation| is nil, returns an empty HotkeyBox.
+ (id)hotkeyBoxWithPreferencesRepresentation:(NSDictionary *)preferencesRepresentation;

// Returns an empty autoreleased instance of HotkeyBox.
+ (id)emptyHotkeyBox;

// Provides a representation suitable for storing in preferences.
- (NSDictionary *)preferencesRepresentation;

@end
