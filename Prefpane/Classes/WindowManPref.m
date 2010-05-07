//
//  WindowManPref.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright (c) 2010 Nolan Waite. All rights reserved.
//

#import "WindowManPref.h"
#import "WindowManHotkeyTextView.h"
#import "NWLoginItems.h"


@interface WindowManPref ()

// Returns the path of |bundledApp| relative to this bundle's Resources directory.
- (NSString *)pathForBundledApp:(NSString *)bundledApp;

@end


@implementation WindowManPref

@synthesize hotkeyTable;
@synthesize helperStartOnLoginCheckBox;

- (id)initWithBundle:(NSBundle *)bundle
{
  self = [super initWithBundle:bundle];
  if (self != nil)
  {
    hotkeys = [[NSMutableArray alloc] init];
    for (NSString *key in WindowManHotkeyPreferences())
    {
      [hotkeys addObject:[NWHotkeyBox hotkeyBoxWithPreferencesRepresentation:[WindowManCommonPreferences valueForKey:key]]];
    }
  }
  
  return self;
}

- (void)dealloc
{
  [hotkeyTable release];
  [hotkeys release];
  
  [super dealloc];
}

- (void)willSelect
{
  self.helperStartOnLoginCheckBox.state = [NWLoginItems isBundleAtPathInSessionLoginItems:[self pathForBundledApp:@"WindowManHelper.app"]] ? NSOnState : NSOffState;
}

- (NSString *)pathForBundledApp:(NSString *)bundledApp
{
  return [[[self bundle] resourcePath] stringByAppendingPathComponent:bundledApp];
}

- (IBAction)toggleStartWindowManHelperOnLogin:(id)sender
{
  NSString *helperPath = [self pathForBundledApp:@"WindowManHelper.app"];
  if ([sender state])
  {
    [NWLoginItems addBundleAtPathToSessionLoginItems:helperPath];
  }
  else
  {
    [NWLoginItems removeBundleAtPathFromSessionLoginItems:helperPath];
  }
}

// NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
  return [hotkeys count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(NSInteger)rowIndex
{
  if ([[column identifier] isEqual:@"name"])
  {
    return [WindowManCommonPreferences localizedDescriptionWithPreference:[WindowManHotkeyPreferences() objectAtIndex:rowIndex]];
  }
  else
  {
    static NWHotkeyStringTransformer *transformer = nil;
    if (transformer == nil)
    {
      transformer = [[NWHotkeyStringTransformer alloc] init];
    }
    id hotkey = [hotkeys objectAtIndex:rowIndex];
    if ([hotkey isEqual:[NSNull null]])
    {
      return @"(none)";
    }
    return [transformer transformedValue:hotkey];
  }
}

- (void)controlTextDidEndEditing:(NSNotification *)note
{
  // Update table view source.
  NSUInteger prefIndex = [hotkeyTable selectedRow];
  [hotkeys replaceObjectAtIndex:prefIndex withObject:[(WindowManHotkeyTextView *)[[note userInfo] valueForKey:@"NSFieldEditor"] hotkey]];
  
  // Update preferences.
  NSString *prefKey = [WindowManHotkeyPreferences() objectAtIndex:prefIndex];
  [WindowManCommonPreferences setValue:[[hotkeys objectAtIndex:prefIndex] preferencesRepresentation] forKey:prefKey];
  [WindowManCommonPreferences synchronize];
  
  // Notify other WindowMan apps about changed preference.
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:prefKey, WindowManChangedPreferenceKey, nil];
  NSDistributedNotificationCenter *noteCenter = [NSDistributedNotificationCenter defaultCenter];
  [noteCenter postNotificationName:(NSString *)WindowManHotkeyPreferencesDidChangeNotification object:nil userInfo:userInfo];
}

@end
