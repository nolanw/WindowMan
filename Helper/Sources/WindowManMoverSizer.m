//
//  WindowManMoverSizer.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-07.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManMoverSizer.h"


#ifndef WINDOWMAN_MOVER_SIZER
#define WINDOWMAN_MOVER_SIZER

// Macro to wrap CFRelease with a check for NULL.
#define NiceCFRelease(ptr) if (ptr != NULL) { CFRelease(ptr); ptr = NULL; }

#endif /* ndef WINDOWMAN_MOVER_SIZER */


@interface WindowManMoverSizer ()

// Return the currently-focused window in the currently-focused application. Caller needs to release
// a non-NULL return value.
+ (AXUIElementRef)currentlyFocusedWindow;

// Return the size and origin (in screen coordinates) of |window|.
// ret: (on error) CGRectZero
+ (CGRect)rectForWindow:(AXUIElementRef)window;

// Sets |window|'s origin and size to those of |rect|.
+ (void)setRect:(CGRect)rect forWindow:(AXUIElementRef)window;

// Returns the visible frame of the screen where |window| is found.
+ (CGRect)visibleScreenFrameForWindow:(AXUIElementRef)window;

@end


@implementation WindowManMoverSizer

+ (AXUIElementRef)currentlyFocusedWindow
{  
  AXError error;
  
  AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
  
  AXUIElementRef currentlyFocusedApp;
  error = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute, (CFTypeRef *)&currentlyFocusedApp);
  if (error != kAXErrorSuccess)
  {
    goto cleanup;
  }
  
  AXUIElementRef currentlyFocusedWindow;
  error = AXUIElementCopyAttributeValue(currentlyFocusedApp, (CFStringRef)NSAccessibilityFocusedWindowAttribute, (CFTypeRef *)&currentlyFocusedWindow);
  if (error != kAXErrorSuccess || CFGetTypeID(currentlyFocusedWindow) != AXUIElementGetTypeID())
  {
    NiceCFRelease(currentlyFocusedWindow);
    goto cleanup;
  }
  
  cleanup:;
  NiceCFRelease(currentlyFocusedApp);
  NiceCFRelease(systemWideElement);
  
  return currentlyFocusedWindow;
}

+ (CGRect)rectForWindow:(AXUIElementRef)window
{
  AXError error;
  CGPoint windowOrigin;
  CGSize windowSize;
  
  CFTypeRef position;
  error = AXUIElementCopyAttributeValue(window, (CFStringRef)NSAccessibilityPositionAttribute, &position);
  if (error != kAXErrorSuccess || AXValueGetType(position) != kAXValueCGPointType)
  {
    NiceCFRelease(position);
    goto errorReturn;
  }
  AXValueGetValue(position, kAXValueCGPointType, &windowOrigin);
  NiceCFRelease(position);
  
  CFTypeRef size;
  error = AXUIElementCopyAttributeValue(window, (CFStringRef)NSAccessibilitySizeAttribute, &size);
  if (error != kAXErrorSuccess || AXValueGetType(size) != kAXValueCGSizeType)
  {
    NiceCFRelease(size);
    goto errorReturn;
  }
  AXValueGetValue(size, kAXValueCGSizeType, &windowSize);
  NiceCFRelease(size);
  
  CGRect windowRect = CGRectMake(windowOrigin.x, windowOrigin.y, windowSize.width, windowSize.height);
  NSLog(@"%s currentlyFocusedWindow rect: %@", _cmd, NSStringFromRect(NSRectFromCGRect(windowRect)));
  
  return windowRect;
  
  errorReturn:;
  return CGRectZero;
}

+ (void)setRect:(CGRect)rect forWindow:(AXUIElementRef)window
{
  AXError error;
  
  CFTypeRef origin;
  CFTypeRef size;
  CFTypeRef windowTitle;
  
  error = AXUIElementCopyAttributeValue(window, kAXTitleAttribute, &windowTitle);
  if (error != kAXErrorSuccess || AXValueGetType(windowTitle) != CFStringGetTypeID())
  {
    windowTitle = CFSTR("");
  }
  
  origin = AXValueCreate(kAXValueCGPointType, &(rect.origin));
  size = AXValueCreate(kAXValueCGSizeType, &(rect.size));
  
  error = AXUIElementSetAttributeValue(window, (CFStringRef)NSAccessibilityPositionAttribute, origin);
  if (error != kAXErrorSuccess)
  {
    NSLog(@"%s error setting position for window %@", _cmd, windowTitle);
  }
  
  error = AXUIElementSetAttributeValue(window, (CFStringRef)NSAccessibilitySizeAttribute, size);
  if (error != kAXErrorSuccess)
  {
    NSLog(@"%s error setting size for window %@", _cmd, windowTitle);
  }
  
  NiceCFRelease(windowTitle);
  NiceCFRelease(size);
  NiceCFRelease(origin);
}

+ (CGRect)visibleScreenFrameForWindow:(AXUIElementRef)window
{
  return NSRectToCGRect([[NSScreen mainScreen] visibleFrame]);
}

static void HalfsiesCGRect(CGRect inRect, CGRect *outRects)
{
  return CGRectDivide(inRect, outRects, outRects + 1, (inRect.size.width / 2.0), CGRectMinXEdge);
}


+ (void)occupyLeftHalf
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenHalves[2];
  HalfsiesCGRect([self visibleScreenFrameForWindow:window], screenHalves);
  [self setRect:screenHalves[0] forWindow:window];
  NiceCFRelease(window);
}

+ (void)occupyRightHalf
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenHalves[2];
  HalfsiesCGRect([self visibleScreenFrameForWindow:window], screenHalves);
  [self setRect:screenHalves[1] forWindow:window];
  NiceCFRelease(window);
}


+ (void)occupyTopLeftQuarter
{
  
}

+ (void)occupyTopRightQuarter
{
  
}

+ (void)occupyBottomRightQuarter
{
  
}

+ (void)occupyBottomLeftQuarter
{
  
}


+ (void)occupyCenter
{
  
}

+ (void)occupyEntireScreen
{
  
}

@end
