//
//  TOSlide.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOSlide.h"

@implementation TOSlide

@synthesize image = _image;
@synthesize color = _color;
@synthesize label = _label;

+ (TOSlide *)slideWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label;
{
    return [[TOSlide alloc] initWithImage:image color:color label:label];
}


- (id)initWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label
{
    self = [super init];
    if (self) {
        self.image = image;
        self.color = color;
        self.label = label;
    }
    
    return self;
}


@end
