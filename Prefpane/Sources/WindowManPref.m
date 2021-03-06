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

// Sets |hotkey| to the value of the preference at |prefIndex|.
- (void)setHotkey:(NWHotkeyBox *)hotkey forPreferenceAtIndex:(NSUInteger)prefIndex;

@end


@implementation WindowManPref

@synthesize hotkeyTable;
@synthesize helperStartOnLoginCheckBox;
@synthesize helperIsRunningCheckBox;
@synthesize menuStartOnLoginCheckBox;
@synthesize menuIsRunningCheckBox;
@synthesize accessibilityAPIEnabledTabView;
@synthesize openUniversalAccessPrefpaneButton;

static NSString * WindowManAccessibilityEnabledTabViewItemID = @"AccessibilityEnabled";
static NSString * WindowManAccessibilityDisabledTabViewItemID = @"AccessibilityDisabled";
static NSString * WindowManUniversalAccessPrefpanePath = @"/System/Library/PreferencePanes/UniversalAccessPref.prefPane";
static NSString * WindowManHelperAppFilename = @"WindowManHelper.app";
static NSString * WindowManMenuAppFilename = @"WindowManMenu.app";
static NSString * WindowManPrefpaneHotkeyColumnID = @"hotkey";
static NSString * WindowManWebsite = @"http://nolanw.ca/windowman/";

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
  [self.hotkeyTable setTarget:self];
  [self.hotkeyTable setDoubleAction:@selector(editSelectedRowHotkeyInTable:)];
}

- (void)willSelect
{
  if (!AXAPIEnabled())
  {
    [self.accessibilityAPIEnabledTabView selectTabViewItemWithIdentifier:WindowManAccessibilityDisabledTabViewItemID];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    [self.openUniversalAccessPrefpaneButton setHidden:![fileManager isExecutableFileAtPath:WindowManUniversalAccessPrefpanePath]];
    [self.openUniversalAccessPrefpaneButton setEnabled:![self.openUniversalAccessPrefpaneButton isHidden]];
  }
  else
  {
    [self.accessibilityAPIEnabledTabView selectTabViewItemWithIdentifier:WindowManAccessibilityEnabledTabViewItemID];
  }
  [self.helperStartOnLoginCheckBox setState:([NWLoginItems isBundleAtPathInSessionLoginItems:[self pathForBundledApp:WindowManHelperAppFilename]] ? NSOnState : NSOffState)];
  [self.helperIsRunningCheckBox setState:(([[NSRunningApplication runningApplicationsWithBundleIdentifier:WindowManHelperBundleIdentifier] count] > 0) ? NSOnState : NSOffState)];
  [self.menuStartOnLoginCheckBox setState:([NWLoginItems isBundleAtPathInSessionLoginItems:[self pathForBundledApp:WindowManMenuAppFilename]] ? NSOnState : NSOffState)];
  [self.menuIsRunningCheckBox setState:(([[NSRunningApplication runningApplicationsWithBundleIdentifier:WindowManMenuBundleIdentifier] count] > 0) ? NSOnState : NSOffState)];
}

- (NSString *)pathForBundledApp:(NSString *)bundledApp
{
  return [[[self bundle] resourcePath] stringByAppendingPathComponent:bundledApp];
}

- (IBAction)toggleStartWindowManHelperOnLogin:(id)sender
{
  NSString *helperPath = [self pathForBundledApp:WindowManHelperAppFilename];
  if ([sender state] == NSOnState)
  {
    [NWLoginItems addBundleAtPathToSessionLoginItems:helperPath];
  }
  else
  {
    [NWLoginItems removeBundleAtPathFromSessionLoginItems:helperPath];
  }
}

- (IBAction)toggleHelperAppRunning:(id)sender
{
  if ([sender state] == NSOnState)
  {
    NSURL *helperURL = [NSURL fileURLWithPath:[self pathForBundledApp:WindowManHelperAppFilename]];
    [[NSWorkspace sharedWorkspace] launchApplicationAtURL:helperURL options:NSWorkspaceLaunchWithoutActivation configuration:[NSDictionary dictionary] error:nil];
  }
  else
  {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:WindowManTerminateHelperAppNotification object:nil];
  }
}

- (IBAction)toggleStartWindowManMenuOnLogin:(id)sender
{
  NSString *menuPath = [self pathForBundledApp:WindowManMenuAppFilename];
  if ([sender state] == NSOnState)
  {
    [NWLoginItems addBundleAtPathToSessionLoginItems:menuPath];
  }
  else
  {
    [NWLoginItems removeBundleAtPathFromSessionLoginItems:menuPath];
  }
}
- (IBAction)toggleMenuAppRunning:(id)sender
{
  if ([sender state] == NSOnState)
  {
    NSURL *menuURL = [NSURL fileURLWithPath:[self pathForBundledApp:WindowManMenuAppFilename]];
    [[NSWorkspace sharedWorkspace] launchApplicationAtURL:menuURL options:NSWorkspaceLaunchWithoutActivation configuration:[NSDictionary dictionary] error:nil];
  }
  else
  {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:WindowManTerminateMenuAppNotification object:nil];
  }
}

- (IBAction)openUniversalAccessPrefpane:(id)sender
{
  [[NSWorkspace sharedWorkspace] openFile:WindowManUniversalAccessPrefpanePath withApplication:nil andDeactivate:NO];
}

- (IBAction)editSelectedRowHotkeyInTable:(NSTableView *)tableView
{
  NSUInteger clickedRow = [tableView clickedRow];
  if (clickedRow == -1)
  {
    return;
  }
  [tableView editColumn:[tableView columnWithIdentifier:WindowManPrefpaneHotkeyColumnID] row:clickedRow withEvent:nil select:YES];
}

- (IBAction)openWindowManWebsite:(id)sender
{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:WindowManWebsite]];
}

- (void)setHotkey:(NWHotkeyBox *)hotkey forPreferenceAtIndex:(NSUInteger)prefIndex
{
  [hotkeys replaceObjectAtIndex:prefIndex withObject:hotkey];
  
  // Update preferences.
  NSString *prefKey = [WindowManHotkeyPreferences() objectAtIndex:prefIndex];
  NSDictionary *prefValue = [[hotkeys objectAtIndex:prefIndex] preferencesRepresentation];
  [WindowManCommonPreferences setValue:prefValue forKey:prefKey];
  [WindowManCommonPreferences synchronize];
  
  // Notify other WindowMan apps about changed preference.
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:prefKey, WindowManUserInfoPreferenceKey, nil];
  NSDistributedNotificationCenter *noteCenter = [NSDistributedNotificationCenter defaultCenter];
  [noteCenter postNotificationName:WindowManHotkeyPreferencesDidChangeNotification object:nil userInfo:userInfo];
}

// NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
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

// DeleteKeyTableViewDelegate

- (void)tableViewDidReceiveDelete:(NSTableView *)tableView
{
  if ([hotkeyTable selectedRow] == -1)
  {
    return;
  }
  [self setHotkey:[NWHotkeyBox emptyHotkeyBox] forPreferenceAtIndex:[hotkeyTable selectedRow]];
  [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[hotkeyTable selectedRow]] columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
}

// NSControlTextEditingDelegate

- (void)controlTextDidEndEditing:(NSNotification *)note
{
  // Update table view source.
  NSUInteger prefIndex = [hotkeyTable selectedRow];
  NWHotkeyBox *hotkey = [(WindowManHotkeyTextView *)[[note userInfo] valueForKey:@"NSFieldEditor"] hotkey];
  if (hotkey == nil)
  {
    // Not changing preferences (e.g. user canceled editing).
    return;
  }
  [self setHotkey:hotkey forPreferenceAtIndex:prefIndex];
}

@end
