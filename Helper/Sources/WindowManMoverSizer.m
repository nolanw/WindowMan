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

// Sets |window|'s origin to |origin|.
+ (void)setOrigin:(CGPoint)origin forWindow:(AXUIElementRef)window;

// Sets |window|'s size to |size|.
+ (void)setSize:(CGSize)size forWindow:(AXUIElementRef)window;

// Returns the screen in which |window|'s origin is contained.
+ (NSScreen *)screenForWindow:(AXUIElementRef)window;

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
  
  return windowRect;
  
  errorReturn:;
  return CGRectZero;
}

+ (void)setRect:(CGRect)rect forWindow:(AXUIElementRef)window
{
  [self setOrigin:rect.origin forWindow:window];
  [self setSize:rect.size forWindow:window];
}

// Sets |window|'s origin to |origin|.
+ (void)setOrigin:(CGPoint)origin forWindow:(AXUIElementRef)window
{
  AXError error;
  
  CFTypeRef originValue;
  CFTypeRef windowTitle;
  
  error = AXUIElementCopyAttributeValue(window, kAXTitleAttribute, &windowTitle);
  if (error != kAXErrorSuccess || AXValueGetType(windowTitle) != CFStringGetTypeID())
  {
    windowTitle = CFSTR("");
  }
  
  originValue = AXValueCreate(kAXValueCGPointType, &origin);
  
  error = AXUIElementSetAttributeValue(window, (CFStringRef)NSAccessibilityPositionAttribute, originValue);
  if (error != kAXErrorSuccess)
  {
    NSLog(@"Could not set the origin of the window named %@. Perhaps the window is fighting an irresistable force.", windowTitle);
  }
  
  NiceCFRelease(windowTitle);
  NiceCFRelease(originValue);
}

// Sets |window|'s size to |size|.
+ (void)setSize:(CGSize)size forWindow:(AXUIElementRef)window
{
  AXError error;
  
  CFTypeRef sizeValue;
  CFTypeRef windowTitle;
  
  error = AXUIElementCopyAttributeValue(window, kAXTitleAttribute, &windowTitle);
  if (error != kAXErrorSuccess || AXValueGetType(windowTitle) != CFStringGetTypeID())
  {
    windowTitle = CFSTR("");
  }
  
  sizeValue = AXValueCreate(kAXValueCGSizeType, &size);
  
  error = AXUIElementSetAttributeValue(window, (CFStringRef)NSAccessibilitySizeAttribute, sizeValue);
  if (error != kAXErrorSuccess)
  {
    NSLog(@"Could not set the size of the window named %@. Perhaps the window is sensitive.", windowTitle);
  }
  
  NiceCFRelease(windowTitle);
  NiceCFRelease(sizeValue);
}

+ (NSScreen *)screenForWindow:(AXUIElementRef)window
{
  NSArray *screens = [NSScreen screens];
  CGFloat zeroScreenHeight = NSHeight([[screens objectAtIndex:0] frame]);
  CGRect windowRect = [self rectForWindow:window];
  CGRect screenRect;
  for (NSScreen *screen in [NSScreen screens])
  {
    screenRect = NSRectToCGRect([screen visibleFrame]);
    // NSRect y increases up; CGRect y increases down; all screens relative to first.
    screenRect.origin.y = zeroScreenHeight - screenRect.origin.y - screenRect.size.height;
    if (CGRectContainsPoint(screenRect, windowRect.origin))
    {
      return screen;
    }
  }
  return nil;
}

+ (CGRect)visibleScreenFrameForWindow:(AXUIElementRef)window
{
  AXError error;
  
  CFTypeRef windowTitle;
  
  error = AXUIElementCopyAttributeValue(window, kAXTitleAttribute, &windowTitle);
  if (error != kAXErrorSuccess)
  {
    windowTitle = CFSTR("");
  }
  
  NSScreen *windowScreen = [self screenForWindow:window];
  if (windowScreen == nil)
  {
    NSLog(@"Failed to locate the window named %@. Perhaps it is playing hide and seek, and you are it.", windowTitle);
    return CGRectZero;
  }
  CGRect visibleFrame = NSRectToCGRect([windowScreen visibleFrame]);
  // NSRect y increases up; CGRect y increases down; all screens relative to first.
  CGFloat zeroScreenHeight = NSHeight([[[NSScreen screens] objectAtIndex:0] frame]);
  visibleFrame.origin.y = zeroScreenHeight - visibleFrame.origin.y - visibleFrame.size.height;
  if ([windowScreen isEqual:[NSScreen mainScreen]])
  {
    visibleFrame.origin.y += [[NSStatusBar systemStatusBar] thickness];
  }
  return visibleFrame;
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
  if (!CGRectEqualToRect(screenHalves[0], CGRectZero))
  {
    [self setRect:screenHalves[0] forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)occupyRightHalf
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenHalves[2];
  HalfsiesCGRect([self visibleScreenFrameForWindow:window], screenHalves);
  if (!CGRectEqualToRect(screenHalves[1], CGRectZero))
  {
    [self setRect:screenHalves[1] forWindow:window];
  }
  NiceCFRelease(window);
}


static void QuartersiesCGRect(CGRect inRect, CGRect *outRects)
{
  CGRect halfsies[2];
  HalfsiesCGRect(inRect, halfsies);
  CGRectDivide(halfsies[0], outRects, outRects + 3, (halfsies[0].size.height / 2.0), CGRectMinYEdge);
  CGRectDivide(halfsies[1], outRects + 1, outRects + 2, (halfsies[1].size.height / 2.0), CGRectMinYEdge);
}

+ (void)occupyTopLeftQuarter
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenQuarters[4];
  QuartersiesCGRect([self visibleScreenFrameForWindow:window], screenQuarters);
  if (!CGRectEqualToRect(screenQuarters[0], CGRectZero))
  {
    [self setRect:screenQuarters[0] forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)occupyTopRightQuarter
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenQuarters[4];
  QuartersiesCGRect([self visibleScreenFrameForWindow:window], screenQuarters);
  if (!CGRectEqualToRect(screenQuarters[4], CGRectZero))
  {
    [self setRect:screenQuarters[1] forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)occupyBottomRightQuarter
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenQuarters[4];
  QuartersiesCGRect([self visibleScreenFrameForWindow:window], screenQuarters);
  if (!CGRectEqualToRect(screenQuarters[2], CGRectZero))
  {
    [self setRect:screenQuarters[2] forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)occupyBottomLeftQuarter
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenQuarters[4];
  QuartersiesCGRect([self visibleScreenFrameForWindow:window], screenQuarters);
  if (!CGRectEqualToRect(screenQuarters[3], CGRectZero))
  {
    [self setRect:screenQuarters[3] forWindow:window];
  }
  NiceCFRelease(window);
}


+ (void)centerHorizontally
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect windowRect = [self rectForWindow:window];
  CGRect screenRect = [self visibleScreenFrameForWindow:window];
  if (!CGRectEqualToRect(screenRect, CGRectZero))
  {
    windowRect.origin.x = screenRect.origin.x + (screenRect.size.width / 2.0) - (windowRect.size.width / 2.0);
    [self setOrigin:windowRect.origin forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)centerAbsolutely
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect windowRect = [self rectForWindow:window];
  CGRect screenRect = [self visibleScreenFrameForWindow:window];
  if (!CGRectEqualToRect(screenRect, CGRectZero))
  {
    windowRect.origin.x = screenRect.origin.x + (screenRect.size.width / 2.0) - (windowRect.size.width / 2.0);
    windowRect.origin.y = screenRect.origin.y + (screenRect.size.height / 2.0) - (windowRect.size.height / 2.0);
    [self setOrigin:windowRect.origin forWindow:window];
  }
  NiceCFRelease(window);
}


+ (void)maximizeVertically
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect windowRect = [self rectForWindow:window];
  CGRect screenRect = [self visibleScreenFrameForWindow:window];
  if (!CGRectEqualToRect(screenRect, CGRectZero))
  {
    windowRect.origin.y = screenRect.origin.y;
    windowRect.size.height = screenRect.size.height;
    [self setRect:windowRect forWindow:window];
  }
  NiceCFRelease(window);
}

+ (void)occupyEntireScreen
{
  AXUIElementRef window = [self currentlyFocusedWindow];
  CGRect screenRect = [self visibleScreenFrameForWindow:window];
  if (!CGRectEqualToRect(screenRect, CGRectZero))
  {
    [self setRect:screenRect forWindow:window];
  }
  NiceCFRelease(window);
}

@end
