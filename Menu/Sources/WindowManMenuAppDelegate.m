//
//  WindowManMenuAppDelegate.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-08.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManMenuAppDelegate.h"


@implementation WindowManMenuAppDelegate

@synthesize statusItemMenu;

- (void)dealloc
{
  [statusItem release];
  
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)note
{
  NSDistributedNotificationCenter *noteCenter = [NSDistributedNotificationCenter defaultCenter];
  [noteCenter addObserver:NSApp selector:@selector(terminate:) name:WindowManTerminateMenuAppNotification object:nil];
  
  statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
  [statusItem setTitle:@"⊞♂"];
  [statusItem setMenu:statusItemMenu];
  [statusItem setHighlightMode:YES];
}

- (IBAction)openWindowManPreferences:(id)sender
{
  NSString *prefpanePath = [[NSBundle mainBundle] bundlePath];
  for (NSUInteger i = 0; i < 3; i++)
  {
    prefpanePath = [prefpanePath stringByAppendingPathComponent:@".."];
  }
  [[NSWorkspace sharedWorkspace] openFile:[prefpanePath stringByStandardizingPath]];
}

@end
