//
//  WindowManHelperAppDelegate.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-06.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHelperAppDelegate.h"
#import "WindowManMoverSizer.h"


@interface WindowManHelperAppDelegate ()

// Returns the boxed hotkey stored for the preference. If no such hotkey is saved, returns 
// an empty boxed hotkey.
- (NWHotkeyBox *)hotkeyForPreference:(NSString *)key;

// Registers hotkey as a global hotkey, storing a reference that can unregister the hotkey.
- (void)registerGlobalHotkey:(NWHotkeyBox *)hotkey forActionAtIndex:(NSUInteger)actionIndex;

// Unregisters the hotkey for action |actionIndex|, if one has been set.
- (void)unregisterGlobalHotkeyAtActionIndex:(NSUInteger)actionIndex;

// Perform the action indicated by the actionIndexth preference.
- (void)performActionAtIndex:(NSUInteger)actionIndex;

// Responds to change in hotkey preference.
- (void)hotkeyPreferenceDidChange:(NSNotification *)note;

@end


@implementation WindowManHelperAppDelegate

- (id)init
{
  self = [super init];
  if (self != nil)
  {
    hotkeyRefs = malloc(sizeof(EventHotKeyRef) * [WindowManHotkeyPreferences() count]);
    if (hotkeyRefs == NULL)
    {
      [self release];
      return nil;
    }
  }
 return self;
}

- (void)dealloc
{
  free(hotkeyRefs);
  hotkeyRefs = NULL;
  
  [super dealloc];
}

- (NWHotkeyBox *)hotkeyForPreference:(NSString *)key
{
  NSDictionary *hotkeyPref = [WindowManCommonPreferences valueForKey:key];
  if (hotkeyPref == nil)
  {
    return [NWHotkeyBox emptyHotkeyBox];
  }
  else
  {
    return [NWHotkeyBox hotkeyBoxWithPreferencesRepresentation:hotkeyPref];
  }
}

- (void)registerGlobalHotkey:(NWHotkeyBox *)hotkey forActionAtIndex:(NSUInteger)actionIndex
{
  if (hotkey.keyCode == NWHotkeyBoxEmpty)
  {
    [self unregisterGlobalHotkeyAtActionIndex:actionIndex];
    return;
  }
  OSStatus error;
  EventHotKeyID hotkeyID;
  EventHotKeyRef hotkeyRef;
  
  hotkeyID.signature = 'WMAN';
  hotkeyID.id = actionIndex;
  error = RegisterEventHotKey([hotkey keyCode], [hotkey carbonModifierFlags], hotkeyID, GetApplicationEventTarget(), kEventHotKeyExclusive, &hotkeyRef);
  if (error)
  {
    hotkeyRef = NULL;
  }
  hotkeyRefs[actionIndex] = hotkeyRef;
}

- (void)unregisterGlobalHotkeyAtActionIndex:(NSUInteger)actionIndex
{
  if (hotkeyRefs[actionIndex] != NULL)
  {
    UnregisterEventHotKey(hotkeyRefs[actionIndex]);
    hotkeyRefs[actionIndex] = NULL;
  }
}

- (void)hotkeyPreferenceDidChange:(NSNotification *)note
{
  NSString *prefKey = [[note userInfo] objectForKey:WindowManUserInfoPreferenceKey];
  if (prefKey == nil)
  {
    return;
  }
  [WindowManCommonPreferences synchronize];
  NSUInteger actionIndex = [WindowManHotkeyPreferences() indexOfObject:prefKey];
  [self unregisterGlobalHotkeyAtActionIndex:actionIndex];
  [self registerGlobalHotkey:[self hotkeyForPreference:prefKey] forActionAtIndex:actionIndex];
}

OSStatus HotkeyHandler(EventHandlerCallRef nextHandler, EventRef event, void *userData)
{
  EventHotKeyID hotkeyID;
  GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(EventHotKeyID), NULL, &hotkeyID);
  [(WindowManHelperAppDelegate *)userData performActionAtIndex:hotkeyID.id];
  return noErr;
}

- (void)performActionAtIndex:(NSUInteger)actionIndex
{
  // Basic dispatch table.
  static NSDictionary *actionsByPref = nil;
  if (actionsByPref == nil)
  {
    actionsByPref = [[NSDictionary alloc] initWithObjects:
      [NSArray arrayWithObjects:@"occupyLeftHalf"
      , @"occupyRightHalf"
      , @"occupyTopLeftQuarter"
      , @"occupyTopRightQuarter"
      , @"occupyBottomRightQuarter"
      , @"occupyBottomLeftQuarter"
      , @"centerHorizontally"
      , @"centerAbsolutely"
      , @"occupyEntireScreen"
      , nil]
      forKeys: WindowManHotkeyPreferences()];
  }
  SEL action = sel_registerName([[actionsByPref objectForKey:[WindowManHotkeyPreferences() objectAtIndex:actionIndex]] cStringUsingEncoding:NSASCIIStringEncoding]);
  [WindowManMoverSizer performSelector:action];
}

// NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)note
{
  NSDistributedNotificationCenter *noteCenter = [NSDistributedNotificationCenter defaultCenter];
  [noteCenter addObserver:NSApp selector:@selector(terminate:) name:WindowManTerminateHelperAppNotification object:nil];
  
  EventTypeSpec eventType;
  eventType.eventClass = kEventClassKeyboard;
  eventType.eventKind = kEventHotKeyPressed;
  InstallApplicationEventHandler(&HotkeyHandler, 1, &eventType, self, NULL);
  
  NWHotkeyBox *hotkey;
  for (NSUInteger prefIndex = 0; prefIndex < [WindowManHotkeyPreferences() count]; prefIndex += 1)
  {
    hotkey = [self hotkeyForPreference:[WindowManHotkeyPreferences() objectAtIndex:prefIndex]];
    [self registerGlobalHotkey:hotkey forActionAtIndex:prefIndex];
  }
  
  [noteCenter addObserver:self selector:@selector(hotkeyPreferenceDidChange:) name:WindowManHotkeyPreferencesDidChangeNotification object:nil];
}

@end
