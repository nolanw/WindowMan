#import <CoreFoundation/CoreFoundation.h>
#import "WindowManCommonPreferences.h"

@implementation WindowManCommonPreferences

const CFStringRef WindowManPreferencesIdentifier = (const CFStringRef)@"ca.nolanw.WindowMan";

+ (id)valueForKey:(NSString *)key
{
  CFPropertyListRef value = CFPreferencesCopyAppValue((CFStringRef)key, WindowManPreferencesIdentifier);
  
  return value ? [(id)value autorelease] : nil;
}

+ (void)setValue:(id)value forKey:(NSString *)key
{
  CFPreferencesSetAppValue((CFStringRef)key, value, WindowManPreferencesIdentifier);
}

+ (BOOL)synchronize
{
  return CFPreferencesSynchronize(WindowManPreferencesIdentifier
    , kCFPreferencesCurrentUser
    , kCFPreferencesCurrentHost
    ) ? YES : NO;
}

@end
