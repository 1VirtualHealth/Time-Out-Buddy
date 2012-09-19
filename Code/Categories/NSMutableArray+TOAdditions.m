//
//  NSMutableArray+TOAdditions.m
//  TimeOutBuddy
//
//  Created by John Stallings on 9/18/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "NSMutableArray+TOAdditions.h"

@implementation NSMutableArray (TOAdditions)

- (id)popRandomObject
{
    if ([self count] == 0)
        return nil;
    
    NSUInteger randomIndex = arc4random_uniform([self count]);
    NSAssert(randomIndex >=0 && randomIndex < [self count], @"Random Index should always fall between 0 and [NSArray count]");
    id object = [self objectAtIndex:randomIndex];
    [self removeObject:object];
    return object;
}
@end
