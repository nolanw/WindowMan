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
