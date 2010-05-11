//
//  WindowManMoverSizer.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-07.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// WindowManMoverSizer collects code to locate, resize, and move the currently-focused window, 
// regardless of application.
@interface WindowManMoverSizer : NSObject
{
}

// The following all operate on the currently-focused window in the currently-focused app.

// These both move and resize the window.
+ (void)occupyLeftHalf;
+ (void)occupyRightHalf;

// These also both move and resize the window.
+ (void)occupyTopLeftQuarter;
+ (void)occupyTopRightQuarter;
+ (void)occupyBottomRightQuarter;
+ (void)occupyBottomLeftQuarter;

// This just moves the window.
+ (void)centerHorizontally;
+ (void)centerAbsolutely;

// This just resizes the window.
+ (void)maximizeVertically;

// This both moves and resizes the window.
+ (void)occupyEntireScreen;

@end
