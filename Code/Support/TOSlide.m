//
//  TOSlide.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOSlide.h"

@interface TOSlide()

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, readwrite, strong) UIImage *image;
@end


@implementation TOSlide

+ (TOSlide *)slideWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label duration:(NSTimeInterval)duration;
{
    return [[TOSlide alloc] initWithImage:image color:color label:label duration:duration];
}


- (id)initWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        self.image = image;
        self.color = color;
        self.label = label;
        self.duration = duration;
    }
    
    return self;
}

+(TOSlide *)slideWithImageName:(NSString *)imageName color:(UIColor *)color label:(NSString *)label duration:(NSTimeInterval)duration
{
    return [[TOSlide alloc] initWithImageName:imageName color:color label:label duration:duration];
}
- (id)initWithImageName:(NSString *)imageName color:(UIColor *)color label:(NSString *)label duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.color = color;
        self.label = label;
        self.duration = duration;
    }
    
    return self;
}

- (UIImage *)image
{
    if (_image == nil) {
        _image = [UIImage imageNamed:self.imageName];
    }
    
    return _image;
}


@end
