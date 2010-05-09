//
//  WindowManMenuAppDelegate.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-08.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManMenuAppDelegate.h"


@interface WindowManMenuAppDelegate ()

// Updates the label and hotkey for the menu item at |key|, if the item exists in the 
// status item's menu; otherwise, does nothing.
- (void)updateHotkeyForPreferenceKey:(NSString *)key;

// Sent as menu action to perform the associated window action.
- (IBAction)performWindowAction:(NSMenuItem *)sender;

@end


@implementation WindowManMenuAppDelegate

@synthesize statusItemMenu;

- (void)dealloc
{
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
  [statusItem release];
  
  [super dealloc];
}

- (void)awakeFromNib
{
  if ([statusItemMenu itemWithTag:0])
  {
    return;
  }
  NSArray *hotkeyPrefs = WindowManHotkeyPreferences();
  NSMenuItem *menuItem;
  for (NSUInteger hotkeyPrefIndex = 0; hotkeyPrefIndex < [hotkeyPrefs count]; hotkeyPrefIndex++)
  {
    menuItem = [[[NSMenuItem alloc] init] autorelease];
    [menuItem setTag:hotkeyPrefIndex];
    [menuItem setTarget:self];
    [menuItem setAction:@selector(performWindowAction:)];
    [statusItemMenu insertItem:menuItem atIndex:hotkeyPrefIndex];
    [self updateHotkeyForPreferenceKey:[hotkeyPrefs objectAtIndex:hotkeyPrefIndex]];
  }
}

- (void)applicationDidFinishLaunching:(NSNotification *)note
{
  NSDistributedNotificationCenter *noteCenter = [NSDistributedNotificationCenter defaultCenter];
  [noteCenter addObserver:NSApp selector:@selector(terminate:) name:WindowManTerminateMenuAppNotification object:nil];
  [noteCenter addObserver:self selector:@selector(hotkeyPreferenceDidChange:) name:WindowManHotkeyPreferencesDidChangeNotification object:nil];
  
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

- (void)updateHotkeyForPreferenceKey:(NSString *)key
{
  NSUInteger keyIndex = [WindowManHotkeyPreferences() indexOfObject:key];
  NSMenuItem *menuItem = [statusItemMenu itemWithTag:keyIndex];
  if (menuItem == nil)
  {
    return;
  }
  
  static NWHotkeyStringTransformer *transformer = nil;
  if (transformer == nil)
  {
    transformer = [[NWHotkeyStringTransformer alloc] init];
  }
  NSMutableParagraphStyle *paraStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
  [paraStyle setTabStops:[NSArray array]];
  [paraStyle addTabStop:[[[NSTextTab alloc] initWithType:NSRightTabStopType location:320.0] autorelease]];
  NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
      paraStyle, NSParagraphStyleAttributeName
    , [NSFont menuFontOfSize:14], NSFontAttributeName
    , nil];
  NSString *titleString = [NSString stringWithFormat:@"%@\t%@", [WindowManCommonPreferences localizedDescriptionWithPreference:key], [transformer transformedValue:[NWHotkeyBox hotkeyBoxWithPreferencesRepresentation:[WindowManCommonPreferences valueForKey:key]]]];
  NSAttributedString *title = [[[NSAttributedString alloc] initWithString:titleString attributes:attributes] autorelease];
  [menuItem setAttributedTitle:title];
}

- (IBAction)performWindowAction:(NSMenuItem *)sender
{
  NSLog(@"%s hello; sender: %@", _cmd, sender);
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[WindowManHotkeyPreferences() objectAtIndex:[sender tag]] forKey:WindowManUserInfoPreferenceKey];
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:WindowManPerformActionNotification object:nil userInfo:userInfo];
}

- (void)hotkeyPreferenceDidChange:(NSNotification *)note
{
  [WindowManCommonPreferences synchronize];
  [self updateHotkeyForPreferenceKey:[[note userInfo] objectForKey:WindowManUserInfoPreferenceKey]];
}

@end
