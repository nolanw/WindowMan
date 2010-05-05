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
}

- (void) mainViewDidLoad;

@end
