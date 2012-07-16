//
//  NSArray+TOAdditions.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/13/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "NSArray+TOAdditions.h"

@implementation NSArray (TOAdditions)

- (id)randomObject
{
    if ([self count] == 0)
        return nil;
    
    NSUInteger randomIndex = arc4random_uniform([self count]);
    NSAssert(randomIndex >=0 && randomIndex < [self count], @"Random Index should always fall between 0 and [colorGroup count]");
    return [self objectAtIndex:randomIndex];
}

@end
