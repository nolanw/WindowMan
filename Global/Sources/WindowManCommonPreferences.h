// Common methods to get and set preferences and to get localized descriptive names 
// of preferences from any WindowMan bundle.
@interface WindowManCommonPreferences : NSObject
{
}

// Get a non-Boolean value previously stored using |key|.
// ret: autoreleased instance of previously stored value.
+ (id)valueForKey:(NSString *)key;

// Set a non-Boolean value using |key|, overwriting any values previously set using |key|.
+ (void)setValue:(id)value forKey:(NSString *)key;

// Write cached values to disk and read changed values from disk.
// ret: YES on success; NO otherwise.
+ (BOOL)synchronize;

// Return a localized description of |pref|. Works in any bundle.
+ (NSString *)localizedDescriptionWithPreference:(NSString *)pref;

@end
