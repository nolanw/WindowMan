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
}

@property (nonatomic, retain) IBOutlet NSTableView *hotkeyTable;
@property (nonatomic, retain) IBOutlet NSButton *helperStartOnLoginCheckBox;
@property (nonatomic, retain) IBOutlet NSButton *helperIsRunningCheckBox;

- (IBAction)toggleStartWindowManHelperOnLogin:(id)sender;
- (IBAction)toggleHelperAppRunning:(id)sender;

@end
