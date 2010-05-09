//
//  DeleteKeyTableView.h
//  WindowMan
//
//  Created by Nolan Waite on 10-05-09.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol DeleteKeyTableViewDelegate

// Sent to the delegate when any delete key is pressed without modifiers.
@optional
- (void)tableViewDidReceiveDelete:(NSTableView *)tableView;

@end


@interface DeleteKeyTableView : NSTableView
{
  
}

@end
