//
//  DeleteKeyTableView.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-09.
//  Copyright 2010 Nolan Waite. All rights reserved.
//

#import "DeleteKeyTableView.h"


@implementation DeleteKeyTableView

- (void)keyDown:(NSEvent *)event
{
  if ([event keyCode] == kVK_Delete || [event keyCode] == kVK_ForwardDelete)
  {
    id del = [self delegate];
    if ([del respondsToSelector:@selector(tableViewDidReceiveDelete:)])
    {
      [del tableViewDidReceiveDelete:self];
    }
  }
  else
  {
    [super keyDown:event];
  }
}

@end
