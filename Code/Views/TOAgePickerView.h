//
//  TOAgePickerView.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^AgePickerBlock)();


@interface TOAgePickerView : UIView

@property(copy, nonatomic) AgePickerBlock onPickerDone;
@property(nonatomic) NSDictionary *currentAge;

- (void)reload;

@end
