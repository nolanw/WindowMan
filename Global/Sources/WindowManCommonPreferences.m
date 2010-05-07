//
//  WindowManCommonPreferences.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright 2010 Nolan Waite. All rights reserved.
//


#import <CoreFoundation/CoreFoundation.h>
#import "WindowManCommonPreferences.h"

// Dummy class used to find whatever bundle we've been linked into.
@interface WindowManCommonPreferencesBundleFinder : NSObject {} @end
@implementation WindowManCommonPreferencesBundleFinder @end

@implementation WindowManCommonPreferences

CFStringRef WindowManPreferencesIdentifier = (const CFStringRef)@"ca.nolanw.WindowMan";

NSString * WindowManLocalizedPreferenceDescriptionTable = @"WindowManPreferences";

+ (id)valueForKey:(NSString *)key
{
  CFPropertyListRef value = CFPreferencesCopyAppValue((CFStringRef)key, WindowManPreferencesIdentifier);
  
  return value ? [(id)value autorelease] : nil;
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
  // Why is it necessary to retain then release the key?
  [key retain];
  CFPreferencesSetAppValue((CFStringRef)key, value, WindowManPreferencesIdentifier);
  [key release];
}

+ (BOOL)synchronize
{
  return CFPreferencesSynchronize(WindowManPreferencesIdentifier
    , kCFPreferencesCurrentUser
    , kCFPreferencesAnyHost
    ) ? YES : NO;
}

+ (NSString *)localizedDescriptionWithPreference:(NSString *)pref
{
  NSBundle *thisBundle = [NSBundle bundleForClass:[WindowManCommonPreferencesBundleFinder class]];
  return [thisBundle localizedStringForKey:pref value:pref table:WindowManLocalizedPreferenceDescriptionTable];
}

@end
