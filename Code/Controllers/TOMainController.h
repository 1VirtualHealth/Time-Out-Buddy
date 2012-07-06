//
//  TOMainController.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradientButton;

typedef void (^EndTimeOutBlock)();

@interface TOMainController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *slideLabel;
@property (nonatomic, strong) IBOutlet GradientButton *endButton;

@property (nonatomic, assign) NSDictionary *ageGroup;

@property (nonatomic, copy) EndTimeOutBlock onEndTimeOut;

- (IBAction)endTimeOutPressed:(id)sender;


@end
