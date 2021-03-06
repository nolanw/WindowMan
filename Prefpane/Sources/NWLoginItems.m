//
//  NWLoginItems.m
//  UWWeather
//
//  Created by Nolan Waite on 09-12-04.
//  Copyright 2009 Nolan Waite. All rights reserved.
//

#import "NWLoginItems.h"


@interface NWLoginItems ()

// Obtain and return a reference to the session login items file list.
// Must CFRelease it when done.
+ (LSSharedFileListRef)_sessionLoginItems;

// Obtain and return a reference to the session login item corresponding to 
// |bundle|, or NULL if no such item exists. If return value is not NULL, 
// must CFRelease when done.
+ (LSSharedFileListItemRef)_sessionLoginItemForBundleAtPath:(NSString *)path;

@end

@implementation NWLoginItems

+ (LSSharedFileListRef)_sessionLoginItems
{
  LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
  return loginItems;
}

+ (LSSharedFileListItemRef)_sessionLoginItemForBundleAtPath:(NSString *)path
{
  LSSharedFileListRef loginItems = [self _sessionLoginItems];
  if (loginItems == NULL)
  {
    return NULL;
  }
  NSURL *bundleURL = [NSURL fileURLWithPath:path];
  UInt32 seed;
  CFArrayRef snapshot = LSSharedFileListCopySnapshot(loginItems, &seed);
  CFIndex snapshotIndex = CFArrayGetCount(snapshot);
  LSSharedFileListItemRef item;
  LSSharedFileListItemRef ret = NULL;
  CFURLRef itemURL;
  OSErr error;
  while (snapshotIndex-- && ret == NULL)
  {
    item = (LSSharedFileListItemRef)CFArrayGetValueAtIndex(snapshot, snapshotIndex);
    error = LSSharedFileListItemResolve(item, 0, &itemURL, NULL);
    if (itemURL == NULL || error != noErr)
      continue;
    if ([bundleURL isEqual:(NSURL *)itemURL])
      ret = (LSSharedFileListItemRef)CFRetain(item);
    CFRelease(itemURL);
  }
  CFRelease(snapshot);
  CFRelease(loginItems);
  return ret;
}

void EnsureBundle(NSBundle **bundle)
{
  if (*bundle == nil)
    *bundle = [NSBundle mainBundle];
}

+ (void)addBundleToSessionLoginItems:(NSBundle *)bundle
{
  EnsureBundle(&bundle);
  [self addBundleAtPathToSessionLoginItems:[bundle bundlePath]];
}

+ (void)addBundleAtPathToSessionLoginItems:(NSString *)path
{
  NSURL *bundleURL = [NSURL fileURLWithPath:path];
  LSSharedFileListRef loginItems = [self _sessionLoginItems];
  if (loginItems == NULL)
  {
    return;
  }
  LSSharedFileListItemRef item = [self _sessionLoginItemForBundleAtPath:path];
  if (item == NULL)
    item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, (CFURLRef)bundleURL, NULL, NULL);
  CFRelease(item);
  CFRelease(loginItems);
}

+ (void)removeBundleFromSessionLoginItems:(NSBundle *)bundle
{
  EnsureBundle(&bundle);
  return [self removeBundleAtPathFromSessionLoginItems:[bundle bundlePath]];
}

+ (void)removeBundleAtPathFromSessionLoginItems:(NSString *)path
{
  LSSharedFileListRef loginItems = [self _sessionLoginItems];
  if (loginItems == NULL)
  {
    return;
  }
  LSSharedFileListItemRef item = [self _sessionLoginItemForBundleAtPath:path];
  if (item != NULL)
  {
    LSSharedFileListItemRemove(loginItems, item);
    CFRelease(item);
  }
  CFRelease(loginItems);
}

+ (BOOL)isBundleInSessionLoginItems:(NSBundle *)bundle
{
  EnsureBundle(&bundle);
  return [self isBundleAtPathInSessionLoginItems:[bundle bundlePath]];
}

+ (BOOL)isBundleAtPathInSessionLoginItems:(NSString *)path
{
  LSSharedFileListItemRef item = [self _sessionLoginItemForBundleAtPath:path];
  if (item == NULL)
    return NO;
  CFRelease(item);
  return YES;
}

@end
