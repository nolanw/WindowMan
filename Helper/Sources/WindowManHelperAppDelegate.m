//
//  WindowManHelperAppDelegate.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-06.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "WindowManHelperAppDelegate.h"


@interface WindowManHelperAppDelegate ()

// Returns the boxed hotkey stored for the preference. If no such hotkey is saved, returns 
// an empty boxed hotkey.
- (NWHotkeyBox *)hotkeyForPreference:(NSString *)key;

// Registers hotkey as a global hotkey, and returns a reference that can be used to unregister 
// the hotkey in the future.
- (EventHotKeyRef)registerGlobalHotkey:(NWHotkeyBox *)hotkey forActionAtIndex:(NSUInteger)actionIndex;

// Perform the action indicated by the actionIndexth preference.
- (void)performActionAtIndex:(NSUInteger)actionIndex;

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

- (EventHotKeyRef)registerGlobalHotkey:(NWHotkeyBox *)hotkey forActionAtIndex:(NSUInteger)actionIndex
{
  if (hotkey.keyCode == NWHotkeyBoxEmpty)
  {
    return NULL;
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
  return hotkeyRef;
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
  NSLog(@"%s hotkey for action %d", _cmd, actionIndex);
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
    hotkeyRefs[prefIndex] = [self registerGlobalHotkey:hotkey forActionAtIndex:prefIndex];
  }
}

@end
