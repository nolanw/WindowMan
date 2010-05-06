#import <CoreFoundation/CoreFoundation.h>
#import "WindowManCommonPreferences.h"

// Dummy class used to find whatever bundle we've been linked into.
@interface WindowManCommonPreferencesBundleFinder : NSObject {} @end
@implementation WindowManCommonPreferencesBundleFinder @end

@implementation WindowManCommonPreferences

const CFStringRef WindowManPreferencesIdentifier = (const CFStringRef)@"ca.nolanw.WindowMan";

const NSString * WindowManLocalizedPreferenceDescriptionTable = @"WindowManPreferences";

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

+ (NSString *)localizedDescriptionWithPreference:(NSString *)pref
{
  NSBundle *thisBundle = [NSBundle bundleForClass:[WindowManCommonPreferencesBundleFinder class]];
  return [thisBundle localizedStringForKey:pref value:pref table:(NSString *)WindowManLocalizedPreferenceDescriptionTable];
}

@end