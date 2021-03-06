//
//  WindowManPref.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright (c) 2010 Nolan Waite. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface WindowManPref : NSPreferencePane 
{
  NSMutableArray *hotkeys;
  NSTableView *hotkeyTable;
  NSButton *helperStartOnLoginCheckBox;
  NSButton *helperIsRunningCheckBox;
  NSButton *menuStartOnLoginCheckBox;
  NSButton *menuIsRunningCheckBox;
  NSTabView *accessibilityAPIEnabledTabView;
  NSButton *openUniversalAccessPrefpaneButton;
}

@property (nonatomic, retain) IBOutlet NSTableView *hotkeyTable;
@property (nonatomic, retain) IBOutlet NSButton *helperStartOnLoginCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *helperIsRunningCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *menuStartOnLoginCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *menuIsRunningCheckBox;
@property (nonatomic, retain) IBOutlet NSTabView *accessibilityAPIEnabledTabView;
@property (nonatomic, retain) IBOutlet NSButton *openUniversalAccessPrefpaneButton;

- (IBAction)toggleStartWindowManHelperOnLogin:(id)sender;
- (IBAction)toggleHelperAppRunning:(id)sender;
- (IBAction)toggleStartWindowManMenuOnLogin:(id)sender;
- (IBAction)toggleMenuAppRunning:(id)sender;
- (IBAction)openUniversalAccessPrefpane:(id)sender;
- (IBAction)editSelectedRowHotkeyInTable:(id)sender;
- (IBAction)openWindowManWebsite:(id)sender;

@end
