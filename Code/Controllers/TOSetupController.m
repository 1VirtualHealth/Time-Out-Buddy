//
//  TOSetupController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOSetupController.h"
#import "TOMainController.h"
#import "TOHelpController.h"
#import "TOAgePickerView.h"
#import "GradientButton.h"
#import "Constants.h"
#import "TOChildrenController.h"


@interface TOSetupController ()

@property (strong, nonatomic) TOAgePickerView *agePicker;
@property (nonatomic, strong) UIPopoverController *popover;

- (void)setAgeButtonDisplay:(NSString *)displayString;
- (void)populateVersionLabel;
- (void)showAgePickerPopover;

@end

@implementation TOSetupController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)populateVersionLabel
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.startButton useRedDeleteStyle];
    
    [self populateVersionLabel];
    
    [self setAgeButtonDisplay:nil];
    self.startButton.enabled = NO;
    self.agePicker = [[TOAgePickerView alloc] initWithFrame:CGRectZero];
    __weak TOSetupController *bSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {

        self.agePicker.onPickerDone = ^() {
            if (bSelf.agePicker.currentAge) {
                [bSelf setAgeButtonDisplay:self.agePicker.currentAge[@"name"]];
            }
            else {
                [bSelf setAgeButtonDisplay:nil];
            }
            self.startButton.enabled = self.agePicker.currentAge != nil;
            [bSelf dismissAgePickerAnimated:YES];
        };
        CGRect ageFrame = CGRectMake(0, CGRectGetMinY(self.view.frame) + CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.agePicker.frame), CGRectGetWidth(self.agePicker.frame), CGRectGetHeight(self.agePicker.frame));
        self.agePicker.frame = ageFrame;
        [self.view addSubview:self.agePicker];
        [self dismissAgePickerAnimated:NO];
    }
    else {
        self.agePicker.onPickerDone = ^() {
            if (self.agePicker.currentAge) {
                [bSelf setAgeButtonDisplay:self.agePicker.currentAge[@"name"]];
            }
            else {
                [bSelf setAgeButtonDisplay:nil];
            }
            self.startButton.enabled = self.agePicker.currentAge != nil;

            [bSelf.popover dismissPopoverAnimated:YES];
        };
    }
    

    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setAgeButtonDisplay:(NSString *)displayString
{
    if (displayString == nil) {
        displayString = @"Choose Child or Age";
    }
    [self.selectAgeButton setTitle:displayString forState:UIControlStateNormal];
}

- (void)showAgePickerAnimated:(BOOL)animated
{

    
    if (animated) {
        [UIView beginAnimations:@"slideIn" context:nil];
    }
    
    self.agePicker.frame = CGRectOffset(self.agePicker.frame, 0, -CGRectGetHeight(self.agePicker.frame));

    
    if (animated) {
        [UIView commitAnimations];
    }
}


- (void)dismissAgePickerAnimated:(BOOL)animated
{
    if(animated) {
        [UIView beginAnimations:@"slideOut" context:nil];
    }
    
    self.agePicker.frame = CGRectOffset(self.agePicker.frame, 0, CGRectGetHeight(self.agePicker.frame));
    
    
    if (animated) {
        [UIView commitAnimations];
    }
    
}
- (void)showAgePickerPopover
{
    if (self.popover == nil) {
        UIViewController *controller = [[UIViewController alloc] init];
        self.agePicker.frame = CGRectMake(0,0,320,CGRectGetHeight(self.agePicker.frame));
        

        controller.view.frame = self.agePicker.bounds;
        [controller.view addSubview:self.agePicker];
        controller.modalInPopover = YES;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover setPopoverContentSize:self.agePicker.bounds.size];
    }
    
    [self.popover presentPopoverFromRect:self.selectAgeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
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
    else if ([segue.identifier isEqualToString:@"launchHelpSegue"]) {
        TOHelpController *controller = [segue destinationViewController];
        controller.onEndHelp = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    else if ([segue.identifier isEqualToString:@"childrenSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        TOChildrenController *controller = (TOChildrenController *)navigationController.topViewController;
        controller.onEndBlock = ^{
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
                 
        };
        
    }
}


- (IBAction)settingsPressed:(id)sender
{

}

- (IBAction)chooseAge:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self showAgePickerAnimated:YES];
    }
    else {
        [self showAgePickerPopover];
    }
}

@end
