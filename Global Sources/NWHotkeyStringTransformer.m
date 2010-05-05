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

const NSInteger NWHotkeyControlF1KeyCode = 122;
const NSInteger NWHotkeyControlF2KeyCode = 120;
const NSInteger NWHotkeyControlF3KeyCode = 99;
const NSInteger NWHotkeyControlF4KeyCode = 118;
const NSInteger NWHotkeyControlF5KeyCode = 96;
const NSInteger NWHotkeyControlF6KeyCode = 97;
const NSInteger NWHotkeyControlF7KeyCode = 98;
const NSInteger NWHotkeyControlF8KeyCode = 100;
const NSInteger NWHotkeyControlF9KeyCode = 101;
const NSInteger NWHotkeyControlF10KeyCode = 109;
const NSInteger NWHotkeyControlF11KeyCode = 103;
const NSInteger NWHotkeyControlF12KeyCode = 111;
const NSInteger NWHotkeyControlF13KeyCode = 105;
const NSInteger NWHotkeyControlF14KeyCode = 107;
const NSInteger NWHotkeyControlF15KeyCode = 113;
const NSInteger NWHotkeyControlF16KeyCode = 106;
const NSInteger NWHotkeyControlF17KeyCode = 64;
const NSInteger NWHotkeyControlF18KeyCode = 79;
const NSInteger NWHotkeyControlF19KeyCode = 80;
const NSInteger NWHotkeyControlSpaceKeyCode = 49;
const NSInteger NWHotkeyControlDeleteLeftKeyCode = 51;
const NSInteger NWHotkeyControlDeleteRightKeyCode = 117;
const NSInteger NWHotkeyControlPadClearKeyCode = 71;
const NSInteger NWHotkeyControlLeftArrowKeyCode = 123;
const NSInteger NWHotkeyControlRightArrowKeyCode = 124;
const NSInteger NWHotkeyControlUpArrowKeyCode = 126;
const NSInteger NWHotkeyControlDownArrowKeyCode = 125;
const NSInteger NWHotkeyControlSoutheastArrowKeyCode = 119;
const NSInteger NWHotkeyControlNorthwestArrowKeyCode = 115;
const NSInteger NWHotkeyControlEscapeKeyCode = 53;
const NSInteger NWHotkeyControlPageDownKeyCode = 121;
const NSInteger NWHotkeyControlPageUpKeyCode = 116;
const NSInteger NWHotkeyControlReturnR2LKeyCode = 36;
const NSInteger NWHotkeyControlReturnKeyCode = 76;
const NSInteger NWHotkeyControlTabRightKeyCode = 48;
const NSInteger NWHotkeyControlHelpKeyCode = 114;
const NSInteger NWHotkeyControlNumpadCommaKeyCode = 65;
const NSInteger NWHotkeyControlNumpadAsteriskKeyCode = 67;
const NSInteger NWHotkeyControlNumpadPlusKeyCode = 69;
const NSInteger NWHotkeyControlNumpadSlashKeyCode = 75;
const NSInteger NWHotkeyControlNumpadHyphenKeyCode = 78;
const NSInteger NWHotkeyControlNumpadEqualsKeyCode = 81;
const NSInteger NWHotkeyControlNumpadZeroKeyCode = 82;
const NSInteger NWHotkeyControlNumpadOneKeyCode = 83;
const NSInteger NWHotkeyControlNumpadTwoKeyCode = 84;
const NSInteger NWHotkeyControlNumpadThreeKeyCode = 85;
const NSInteger NWHotkeyControlNumpadFourKeyCode = 86;
const NSInteger NWHotkeyControlNumpadFiveKeyCode = 87;
const NSInteger NWHotkeyControlNumpadSixKeyCode = 88;
const NSInteger NWHotkeyControlNumpadSevenKeyCode = 89;
const NSInteger NWHotkeyControlNumpadEightKeyCode = 91;
const NSInteger NWHotkeyControlNumpadNineKeyCode = 92;


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
    return @"(None)";
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
  return [NSString stringWithFormat:@"%@%@%@%@%@"
    , ((modifierFlags & NSFunctionKeyMask) ? @"Fn-" : @"")
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
        @"F1", BoxInt(NWHotkeyControlF1KeyCode)
      , @"F2", BoxInt(NWHotkeyControlF2KeyCode)
      , @"F3", BoxInt(NWHotkeyControlF3KeyCode)
      , @"F4", BoxInt(NWHotkeyControlF4KeyCode)
      , @"F5", BoxInt(NWHotkeyControlF5KeyCode)
      , @"F6", BoxInt(NWHotkeyControlF6KeyCode)
      , @"F7", BoxInt(NWHotkeyControlF7KeyCode)
      , @"F8", BoxInt(NWHotkeyControlF8KeyCode)
      , @"F9", BoxInt(NWHotkeyControlF9KeyCode)
      , @"F10", BoxInt(NWHotkeyControlF10KeyCode)
      , @"F11", BoxInt(NWHotkeyControlF11KeyCode)
      , @"F12", BoxInt(NWHotkeyControlF12KeyCode)
      , @"F13", BoxInt(NWHotkeyControlF13KeyCode)
      , @"F14", BoxInt(NWHotkeyControlF14KeyCode)
      , @"F15", BoxInt(NWHotkeyControlF15KeyCode)
      , @"F16", BoxInt(NWHotkeyControlF16KeyCode)
      , @"F17", BoxInt(NWHotkeyControlF17KeyCode)
      , @"F18", BoxInt(NWHotkeyControlF18KeyCode)
      , @"F19", BoxInt(NWHotkeyControlF19KeyCode)
      , NWHotkeyControlLocalizedString(@"Space"), BoxInt(NWHotkeyControlSpaceKeyCode)
      , StringWithCodePoint(NWHotkeyControlDeleteLeftCodePoint), BoxInt(NWHotkeyControlDeleteLeftKeyCode)
  		, StringWithCodePoint(NWHotkeyControlDeleteRightCodePoint), BoxInt(NWHotkeyControlDeleteRightKeyCode)
  		, StringWithCodePoint(NWHotkeyControlPadClearCodePoint), BoxInt(NWHotkeyControlPadClearKeyCode)
  		, StringWithCodePoint(NWHotkeyControlLeftArrowCodePoint), BoxInt(NWHotkeyControlLeftArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlRightArrowCodePoint), BoxInt(NWHotkeyControlRightArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlUpArrowCodePoint), BoxInt(NWHotkeyControlUpArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlDownArrowCodePoint), BoxInt(NWHotkeyControlDownArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlSoutheastArrowCodePoint), BoxInt(NWHotkeyControlSoutheastArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlNorthwestArrowCodePoint), BoxInt(NWHotkeyControlNorthwestArrowKeyCode)
  		, StringWithCodePoint(NWHotkeyControlEscapeCodePoint), BoxInt(NWHotkeyControlEscapeKeyCode)
  		, StringWithCodePoint(NWHotkeyControlPageDownCodePoint), BoxInt(NWHotkeyControlPageDownKeyCode)
  		, StringWithCodePoint(NWHotkeyControlPageUpCodePoint), BoxInt(NWHotkeyControlPageUpKeyCode)
  		, StringWithCodePoint(NWHotkeyControlReturnR2LCodePoint), BoxInt(NWHotkeyControlReturnR2LKeyCode)
  		, StringWithCodePoint(NWHotkeyControlReturnCodePoint), BoxInt(NWHotkeyControlReturnKeyCode)
  		, StringWithCodePoint(NWHotkeyControlTabRightCodePoint), BoxInt(NWHotkeyControlTabRightKeyCode)
  		, StringWithCodePoint(NWHotkeyControlHelpCodePoint), BoxInt(NWHotkeyControlHelpKeyCode)
      , nil];
  }
  
  static NSArray *numpadKeyCodes = nil;
  if (numpadKeyCodes == nil)
  {
    numpadKeyCodes = [NSArray arrayWithObjects:
        BoxInt(NWHotkeyControlNumpadCommaKeyCode)
      , BoxInt(NWHotkeyControlNumpadAsteriskKeyCode)
      , BoxInt(NWHotkeyControlNumpadPlusKeyCode)
      , BoxInt(NWHotkeyControlNumpadSlashKeyCode)
      , BoxInt(NWHotkeyControlNumpadHyphenKeyCode)
      , BoxInt(NWHotkeyControlNumpadEqualsKeyCode)
      , BoxInt(NWHotkeyControlNumpadZeroKeyCode)
      , BoxInt(NWHotkeyControlNumpadOneKeyCode)
      , BoxInt(NWHotkeyControlNumpadTwoKeyCode)
      , BoxInt(NWHotkeyControlNumpadThreeKeyCode)
      , BoxInt(NWHotkeyControlNumpadFourKeyCode)
      , BoxInt(NWHotkeyControlNumpadFiveKeyCode)
      , BoxInt(NWHotkeyControlNumpadSixKeyCode)
      , BoxInt(NWHotkeyControlNumpadSevenKeyCode)
      , BoxInt(NWHotkeyControlNumpadEightKeyCode)
      , BoxInt(NWHotkeyControlNumpadNineKeyCode)
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
