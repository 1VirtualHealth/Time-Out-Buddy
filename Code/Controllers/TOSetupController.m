//
//  TOSetupController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOSetupController.h"
#import "TOMainController.h"
#import "TOAgePickerView.h"
#import "GradientButton.h"
#import "Constants.h"

@interface TOSetupController ()

@property (strong, nonatomic) TOAgePickerView *agePicker;

- (void)setAgeButtonDisplay:(NSString *)age;

@end

@implementation TOSetupController

@synthesize agePicker = _agePicker;
@synthesize startButton = _startButton;
@synthesize selectAgeButton = _selectAgeButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.startButton useRedDeleteStyle];
    
    [self.selectAgeButton setTitle:@"Choose Age                  \u25BC" forState:UIControlStateNormal];
    self.agePicker = [[TOAgePickerView alloc] initWithFrame:CGRectZero];
    __weak id bSelf = self;
    self.agePicker.onPickerDone = ^() {
        NSString *ageLabel = [self.agePicker.currentAge valueForKey:@"name"];
        [bSelf setAgeButtonDisplay:ageLabel];
        [bSelf dismissAgePickerAnimated:YES];
    };
    
    //place the agePicker at the bottom
    CGRect ageFrame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.agePicker.frame), CGRectGetWidth(self.agePicker.frame), CGRectGetHeight(self.agePicker.frame));
    self.agePicker.frame = ageFrame;
    [self.view addSubview:self.agePicker];
    
    [self dismissAgePickerAnimated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (isPad()) {
        return YES;
    }
    else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

- (void)setAgeButtonDisplay:(NSString *)age
{
    NSString *ageString = [NSString stringWithFormat:@"%@ years old                 \u25BC", age];
    [self.selectAgeButton setTitle:ageString forState:UIControlStateNormal];
}

- (void)showAgePickerAnimated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"slideIn" context:nil];
    }
    
    self.agePicker.frame = CGRectMake(0,
                                      CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.agePicker.frame) + CGRectGetMinY(self.view.frame),
                                      CGRectGetWidth(self.agePicker.frame),
                                      CGRectGetHeight(self.agePicker.frame));
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)dismissAgePickerAnimated:(BOOL)animated
{
    if(animated) {
        [UIView beginAnimations:@"slideOut" context:nil];
    }
    
    self.agePicker.frame = CGRectMake(0,
                                      CGRectGetHeight(self.view.frame) + CGRectGetMinY(self.view.frame),
                                      CGRectGetWidth(self.agePicker.frame),
                                      CGRectGetHeight(self.agePicker.frame));
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"launchMainSegue"]) {
        TOMainController *controller = [segue destinationViewController];
        controller.ageGroup = self.agePicker.currentAge;
        controller.onEndTimeOut = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}


- (IBAction)chooseAge:(id)sender
{
    [self showAgePickerAnimated:YES];
}

@end