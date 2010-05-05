//
//  WindowManPref.m
//  WindowMan
//
//  Created by Nolan Waite on 10-05-04.
//  Copyright (c) 2010 Nolan Waite. All rights reserved.
//

#import "WindowManPref.h"


@implementation WindowManPref

- (id)initWithBundle:(NSBundle *)bundle
{
  self = [super initWithBundle:bundle];
  if (self != nil)
  {
    hotkeys = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
  }
  
  return self;
}

- (void)dealloc
{
  [hotkeys release];
  
  [super dealloc];
}

- (void) mainViewDidLoad
{
}

// NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
  return 3;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(NSInteger)rowIndex
{
  if ([[column identifier] isEqual:@"name"])
  {
    return [[NSArray arrayWithObjects:@"One", @"Two", @"Three", nil] objectAtIndex:rowIndex];
  }
  else
  {
    return [hotkeys objectAtIndex:rowIndex];
  }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn *)column row:(NSInteger)rowIndex
{
  [hotkeys replaceObjectAtIndex:rowIndex withObject:value];
}

@end
