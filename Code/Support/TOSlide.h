//
//  TOSlide.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOSlide : NSObject

+ (TOSlide *)slideWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label;
- (id)initWithImage:(UIImage *)image color:(UIColor *)color label:(NSString *)label;


@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *label;

@end
