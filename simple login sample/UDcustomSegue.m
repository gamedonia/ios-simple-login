//
//  UDcustomSegue.m
//  simple login sample v2
//
//  Created by Javier Albillos on 24/2/15.
//  Copyright (c) 2015 Gamedonia. All rights reserved.
//

#import "UDcustomSegue.h"

@implementation UDcustomSegue

-(void) perform {
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[[self sourceViewController] navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:[self destinationViewController]];
    [[[self sourceViewController] navigationController] setViewControllers:viewControllers animated:YES];
}

@end
