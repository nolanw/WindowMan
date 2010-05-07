//
//  NWHotkeyBox.m
//  HotkeyControl
//
//  Created by Nolan Waite on 10-05-03.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "NWHotkeyBox.h"
#import <Carbon/Carbon.h>

const NSInteger NWHotkeyBoxEmpty = -1;

static NSString * NWHotkeyBoxPreferencesKeyCodeKey = @"keyCode";
static NSString * NWHotkeyBoxPreferencesModifierFlagsKey = @"modifierFlags";
static NSString * NWHotkeyBoxPreferencesCharacterIgnoringModifiersKey = @"cim";

// Following two sniped from ShortcutRecorder (BSD license).
// TODO: ensure we're following their license here.

NSUInteger SRCarbonToCocoaFlags(NSUInteger carbonFlags)
{
	NSUInteger cocoaFlags = 0;
	
	if (carbonFlags & cmdKey) cocoaFlags |= NSCommandKeyMask;
	if (carbonFlags & optionKey) cocoaFlags |= NSAlternateKeyMask;
	if (carbonFlags & controlKey) cocoaFlags |= NSControlKeyMask;
	if (carbonFlags & shiftKey) cocoaFlags |= NSShiftKeyMask;
	if (carbonFlags & NSFunctionKeyMask) cocoaFlags |= NSFunctionKeyMask;
	
	return cocoaFlags;
}

NSUInteger SRCocoaToCarbonFlags(NSUInteger cocoaFlags)
{
	NSUInteger carbonFlags = 0;
	
	if (cocoaFlags & NSCommandKeyMask) carbonFlags |= cmdKey;
	if (cocoaFlags & NSAlternateKeyMask) carbonFlags |= optionKey;
	if (cocoaFlags & NSControlKeyMask) carbonFlags |= controlKey;
	if (cocoaFlags & NSShiftKeyMask) carbonFlags |= shiftKey;
	if (cocoaFlags & NSFunctionKeyMask) carbonFlags |= NSFunctionKeyMask;
	
	return carbonFlags;
}

@implementation NWHotkeyBox

@synthesize keyCode;
@synthesize modifierFlags;
@dynamic carbonModifierFlags;
@synthesize characterIgnoringModifiers;

- (NSUInteger)carbonModifierFlags
{
  return SRCocoaToCarbonFlags(self.modifierFlags);
}

- (void)setCarbonModifierFlags:(NSUInteger)flags
{
  self.modifierFlags = SRCarbonToCocoaFlags(flags);
}

+ (id)hotkeyBoxWithKeyCode:(NSInteger)aKeyCode modifierFlags:(NSUInteger)someModifierFlags
{
  return [[[self alloc] initWithKeyCode:aKeyCode modifierFlags:someModifierFlags] autorelease];
}

- (id)initWithKeyCode:(NSInteger)aKeyCode modifierFlags:(NSUInteger)someModifierFlags
{
  self = [super init];
  if (self != nil)
  {
    keyCode = aKeyCode;
    modifierFlags = someModifierFlags;
  }
  
  return self;
}

- (id)initWithKeyCode:(NSInteger)aKeyCode carbonModifierFlags:(NSUInteger)someCarbonModifierFlags
{
  return [self initWithKeyCode:aKeyCode modifierFlags:SRCarbonToCocoaFlags(someCarbonModifierFlags)];
}

+ (id)hotkeyBoxWithPreferencesRepresentation:(NSDictionary *)preferencesRepresentation
{
  NWHotkeyBox *hotkeyBox = [[[self alloc] init] autorelease];
  if (preferencesRepresentation == nil)
  {
    hotkeyBox.keyCode = NWHotkeyBoxEmpty;
    return hotkeyBox;
  }
  
  hotkeyBox.keyCode = [[preferencesRepresentation valueForKey:NWHotkeyBoxPreferencesKeyCodeKey] integerValue];
  hotkeyBox.modifierFlags = [[preferencesRepresentation valueForKey:NWHotkeyBoxPreferencesModifierFlagsKey] integerValue];
  hotkeyBox.characterIgnoringModifiers = [[preferencesRepresentation valueForKey:NWHotkeyBoxPreferencesCharacterIgnoringModifiersKey] stringValue];
  return hotkeyBox;
}

+ (id)emptyHotkeyBox
{
  return [[[self alloc] initWithKeyCode:NWHotkeyBoxEmpty modifierFlags:0] autorelease];
}

static id NilToNull(id couldBeNil)
{
  return couldBeNil == nil ? [NSNull null] : nil;
}

// Provides a representation suitable for storing in preferences.
- (NSDictionary *)preferencesRepresentation
{
  return [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInteger:self.keyCode], NWHotkeyBoxPreferencesKeyCodeKey
    , [NSNumber numberWithInteger:self.modifierFlags], NWHotkeyBoxPreferencesModifierFlagsKey
    , NilToNull(self.characterIgnoringModifiers), NWHotkeyBoxPreferencesCharacterIgnoringModifiersKey
    , nil];
}

// NSCopying

- (id)copyWithZone:(NSZone *)zone
{
  return [[[self class] allocWithZone:zone] initWithKeyCode:self.keyCode modifierFlags:self.modifierFlags];
}

// NSKeyValueObserving

+ (NSSet *)keyPathsForValuesAffectingCarbonModifierFlags
{
  return [NSSet setWithObject:@"modifierFlags"];
}

// NSObject

- (NSString *)description
{
  return [[super description] stringByAppendingString:[NSString stringWithFormat:@"(keyCode: %d, modifierFlags: %d", keyCode, modifierFlags]];
}

@end
