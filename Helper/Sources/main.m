//
//  main.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-06.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WindowManHelperAppDelegate.h"

int main(int argc, char *argv[])
{
  WindowManHelperAppDelegate *appDelegate = [[WindowManHelperAppDelegate alloc] init];
  [[NSApplication sharedApplication] setDelegate:appDelegate];
  [NSApp run];
  [appDelegate release];
  return 0;
}
