//
//  NWLoginItems.h
//
//  Created by Nolan Waite on 09-12-04.
//  Copyright 2009 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A Cocoa interface to Launch Services's Shared File List API for setting 
// login items.
@interface NWLoginItems : NSObject {}

// Adds |bundle| to the session login items (this user's login items).
// If |bundle| is nil, mainBundle is used.
// If |bundle| is already in the session login items, no changes are made.
+ (void)addBundleToSessionLoginItems:(NSBundle *)bundle;

// Adds the bundle at |path| to the session login items.
+ (void)addBundleAtPathToSessionLoginItems:(NSString *)path;

// Removes |bundle| from the session login items.
// If |bundle| is nil, mainBundle is used.
// If |bundle| is not in the session login items, no changes are made.
+ (void)removeBundleFromSessionLoginItems:(NSBundle *)bundle;

// Removes the bundle at |path| from the session login items.
+ (void)removeBundleAtPathFromSessionLoginItems:(NSString *)path;

// Returns YES if |bundle| is in the session login items; NO otherwise.
// If |bundle| is nil, mainBundle is used.
+ (BOOL)isBundleInSessionLoginItems:(NSBundle *)bundle;

// Returns YES if the bundle at |path| is in the session login items.
+ (BOOL)isBundleAtPathInSessionLoginItems:(NSString *)path;

@end
