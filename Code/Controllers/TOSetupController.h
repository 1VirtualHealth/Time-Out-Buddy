//
//  TOSetupController.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradientButton;


@interface TOSetupController : UIViewController

@property (nonatomic, strong) IBOutlet GradientButton *startButton;
@property (nonatomic, strong) IBOutlet GradientButton *selectAgeButton;
- (IBAction)chooseAge:(id)sender;
- (IBAction)done:(UIStoryboardSegue *)segue;

@end
