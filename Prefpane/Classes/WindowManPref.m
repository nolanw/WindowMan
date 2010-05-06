//
//  WindowManPref.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright (c) 2010 Nolan Waite. All rights reserved.
//

#import "WindowManPref.h"
#import "WindowManHotkeyTextView.h"


@implementation WindowManPref

@synthesize hotkeyTable;

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

- (void)mainViewDidLoad
{
  
}

// NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
  return [WindowManHotkeyPreferences() count];
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
  [hotkeys replaceObjectAtIndex:[hotkeyTable selectedRow] withObject:[(WindowManHotkeyTextView *)[[note userInfo] valueForKey:@"NSFieldEditor"] hotkey]];
}

@end
