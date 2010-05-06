//
//  NWHotkeyStringTransformer.m
//  HotkeyControl
//
//  Created by Nolan Waite on 10-05-03.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "NWHotkeyStringTransformer.h"
#import <Carbon/Carbon.h>
#import "NWHotkeyBox.h"

// Special keycodes.

const NSInteger NWHotkeyControlPadClearKeyCode = 71;
const NSInteger NWHotkeyControlNumpadCommaKeyCode = 65;

// Useful code points.

const NSInteger NWHotkeyControlDeleteLeftCodePoint = 0x232B;
const NSInteger NWHotkeyControlDeleteRightCodePoint = 0x2326;
const NSInteger NWHotkeyControlPadClearCodePoint = 0x2327;
const NSInteger NWHotkeyControlLeftArrowCodePoint = 0x2190;
const NSInteger NWHotkeyControlRightArrowCodePoint = 0x2192;
const NSInteger NWHotkeyControlUpArrowCodePoint = 0x2191;
const NSInteger NWHotkeyControlDownArrowCodePoint = 0x2193;
const NSInteger NWHotkeyControlSoutheastArrowCodePoint = 0x2198;
const NSInteger NWHotkeyControlNorthwestArrowCodePoint = 0x2196;
const NSInteger NWHotkeyControlEscapeCodePoint = 0x238B;
const NSInteger NWHotkeyControlPageDownCodePoint = 0x21DF;
const NSInteger NWHotkeyControlPageUpCodePoint = 0x21DE;
const NSInteger NWHotkeyControlReturnR2LCodePoint = 0x21A9;
const NSInteger NWHotkeyControlReturnCodePoint = 0x2305;
const NSInteger NWHotkeyControlTabRightCodePoint = 0x21E5;
const NSInteger NWHotkeyControlHelpCodePoint = 0x003F;


// Get whatever bundle this code is in.
// Learned from ShortcutRecorder (BSD license)
// TODO: ensure license compliance
@interface NWHotkeyControlBundleFinder : NSObject {} @end
@implementation NWHotkeyControlBundleFinder @end
NSBundle * NWHotkeyControlBundle()
{
  return [NSBundle bundleForClass:[NWHotkeyControlBundleFinder class]];
}

#ifndef NWHOTKEYCONTROL_LOCALIZATION_FUNCTIONS
#define NWHOTKEYCONTROL_LOCALIZATION_FUNCTIONS

#define NWHotkeyControlLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"NWHotkeyControl", NWHotkeyControlBundle(), nil)

#endif /* ndef NWHOTKEYCONTROL_LOCALIZATION_FUNCTIONS */


@implementation NWHotkeyStringTransformer

+ (Class)transformedValueClass
{
  return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)value
{
  if (value == nil || ![value isKindOfClass:[NWHotkeyBox class]])
  {
    return @"";
  }
  else if ([(NWHotkeyBox *)value keyCode] == NWHotkeyBoxEmpty)
  {
    return @"(none)";
  }
  
  NWHotkeyBox *hotkey = (NWHotkeyBox *)value;
  
  NSString *flagsString = [[self class] stringWithModifierFlags:hotkey.modifierFlags];
  NSString *keyCodeString = (hotkey.characterIgnoringModifiers ? [hotkey.characterIgnoringModifiers uppercaseString] : [[self class] stringWithKeyCode:hotkey.keyCode]);
  
  return [NSString stringWithFormat:@"%@%@", flagsString, keyCodeString];
}

static NSString * StringWithCodePoint(NSUInteger codePoint)
{
  return [NSString stringWithFormat:@"%C", codePoint];
}

static NSNumber * BoxInt(NSInteger anInteger)
{
  return [NSNumber numberWithInteger:anInteger];
}

// Following two methods are barely-modified code from ShortcutRecorder 
// (BSD license).
// TODO: ensure we're following license.

+ (NSString *)stringWithModifierFlags:(NSUInteger)modifierFlags
{
  modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
  return [NSString stringWithFormat:@"%@%@%@%@"
    // , ((modifierFlags & NSFunctionKeyMask) ? @"Fn" : @"")
    , ((modifierFlags & NSControlKeyMask) ? StringWithCodePoint(kControlUnicode) : @"")
    , ((modifierFlags & NSAlternateKeyMask) ? StringWithCodePoint(kOptionUnicode) : @"")
    , ((modifierFlags & NSShiftKeyMask) ? StringWithCodePoint(kShiftUnicode) : @"")
    , ((modifierFlags & NSCommandKeyMask) ? StringWithCodePoint(kCommandUnicode) : @"")
    ];
}

+ (NSString *)stringWithKeyCode:(NSInteger)keyCode
{
  static NSDictionary *specialGlyphs = nil;
  if (specialGlyphs == nil)
  {
    specialGlyphs = [[NSDictionary alloc] initWithObjectsAndKeys:
        @"F1", BoxInt(kVK_F1)
      , @"F2", BoxInt(kVK_F2)
      , @"F3", BoxInt(kVK_F3)
      , @"F4", BoxInt(kVK_F4)
      , @"F5", BoxInt(kVK_F5)
      , @"F6", BoxInt(kVK_F6)
      , @"F7", BoxInt(kVK_F7)
      , @"F8", BoxInt(kVK_F8)
      , @"F9", BoxInt(kVK_F9)
      , @"F10", BoxInt(kVK_F10)
      , @"F11", BoxInt(kVK_F11)
      , @"F12", BoxInt(kVK_F12)
      , @"F13", BoxInt(kVK_F13)
      , @"F14", BoxInt(kVK_F14)
      , @"F15", BoxInt(kVK_F15)
      , @"F16", BoxInt(kVK_F16)
      , @"F17", BoxInt(kVK_F17)
      , @"F18", BoxInt(kVK_F18)
      , @"F19", BoxInt(kVK_F19)
      , NWHotkeyControlLocalizedString(@"Space"), BoxInt(kVK_Space)
      , StringWithCodePoint(NWHotkeyControlDeleteLeftCodePoint), BoxInt(kVK_Delete)
  		, StringWithCodePoint(NWHotkeyControlDeleteRightCodePoint), BoxInt(kVK_ForwardDelete)
  		, StringWithCodePoint(NWHotkeyControlPadClearCodePoint), BoxInt(kVK_ANSI_KeypadClear)
  		, StringWithCodePoint(NWHotkeyControlLeftArrowCodePoint), BoxInt(kVK_LeftArrow)
  		, StringWithCodePoint(NWHotkeyControlRightArrowCodePoint), BoxInt(kVK_RightArrow)
  		, StringWithCodePoint(NWHotkeyControlUpArrowCodePoint), BoxInt(kVK_UpArrow)
  		, StringWithCodePoint(NWHotkeyControlDownArrowCodePoint), BoxInt(kVK_DownArrow)
  		, StringWithCodePoint(NWHotkeyControlEscapeCodePoint), BoxInt(kVK_Escape)
  		, StringWithCodePoint(NWHotkeyControlPageDownCodePoint), BoxInt(kVK_PageDown)
  		, StringWithCodePoint(NWHotkeyControlPageUpCodePoint), BoxInt(kVK_PageUp)
  		, StringWithCodePoint(NWHotkeyControlReturnCodePoint), BoxInt(kVK_Return)
  		, StringWithCodePoint(NWHotkeyControlHelpCodePoint), BoxInt(kVK_Help)
      , NWHotkeyControlLocalizedString(@"Home"), BoxInt(kVK_Home)
      , NWHotkeyControlLocalizedString(@"End"), BoxInt(kVK_End)
      , nil];
  }
  
  static NSArray *numpadKeyCodes = nil;
  if (numpadKeyCodes == nil)
  {
    numpadKeyCodes = [NSArray arrayWithObjects:
        BoxInt(kVK_ANSI_KeypadDecimal)
      , BoxInt(NWHotkeyControlNumpadCommaKeyCode)
      , BoxInt(kVK_ANSI_KeypadMultiply)
      , BoxInt(kVK_ANSI_KeypadPlus)
      , BoxInt(kVK_ANSI_KeypadDivide)
      , BoxInt(kVK_ANSI_KeypadMinus)
      , BoxInt(kVK_ANSI_KeypadEquals)
      , BoxInt(kVK_ANSI_Keypad0)
      , BoxInt(kVK_ANSI_Keypad1)
      , BoxInt(kVK_ANSI_Keypad2)
      , BoxInt(kVK_ANSI_Keypad3)
      , BoxInt(kVK_ANSI_Keypad4)
      , BoxInt(kVK_ANSI_Keypad5)
      , BoxInt(kVK_ANSI_Keypad6)
      , BoxInt(kVK_ANSI_Keypad7)
      , BoxInt(kVK_ANSI_Keypad8)
      , BoxInt(kVK_ANSI_Keypad9)
      , nil];
  }
  
  NSNumber *boxedKeyCode = BoxInt(keyCode);
  
  NSString *specialGlyph = [specialGlyphs objectForKey:boxedKeyCode];
  if (specialGlyph != nil)
  {
    return specialGlyph;
  }
  
  TISInputSourceRef inputSource = TISCopyCurrentKeyboardInputSource();
  if (inputSource == NULL)
  {
    return @"";
  }
  CFDataRef layoutData = (CFDataRef)TISGetInputSourceProperty(inputSource, kTISPropertyUnicodeKeyLayoutData);
  if (layoutData == NULL)
  {
    return @"";
  }
  UCKeyboardLayout *keyboardLayout = (UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
  UInt32 keysDown;
  UniCharCount length = 4;
  UniCharCount realLength;
  UniChar chars[4];
  OSStatus err = UCKeyTranslate(keyboardLayout, keyCode, kUCKeyActionDisplay, 0, LMGetKbdType(), kUCKeyTranslateNoDeadKeysBit, &keysDown, length, &realLength, chars);
  if (err != noErr)
  {
    return @"";
  }
  NSString *keyString = [[NSString stringWithCharacters:chars length:1] uppercaseString];
  if ([numpadKeyCodes containsObject:boxedKeyCode])
  {
    return [NSString stringWithFormat:NWHotkeyControlLocalizedString(@"NumPad %@"), keyString];
  }

  return keyString;
}

@end
