//
//  TOSlideManager.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TOSlide;

typedef void (^TickBlock)(TOSlide *);
typedef void (^CompleteBlock)();

@interface TOSlideManager : NSObject


@property (nonatomic, assign) NSDictionary *ageGroup;
@property (nonatomic, copy) TickBlock onTick;
@property (nonatomic, copy) CompleteBlock onComplete;

- (void)start;

@end
