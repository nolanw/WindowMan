//
//  WindowManMenuAppDelegate.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-08.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WindowManMenuAppDelegate : NSObject
{
  NSStatusItem *statusItem;
  NSMenu *statusItemMenu;
}
@property (nonatomic, retain) IBOutlet NSMenu *statusItemMenu;

- (IBAction)openWindowManPreferences:(id)sender;

@end
