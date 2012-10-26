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


@interface TOSetupController ()

@property (strong, nonatomic) TOAgePickerView *agePicker;
@property (nonatomic, strong) UIPopoverController *popover;

- (void)setAgeButtonDisplay:(NSString *)age;
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
    
    [self.selectAgeButton setTitle:@"Choose Age                  \u25BC" forState:UIControlStateNormal];
    self.agePicker = [[TOAgePickerView alloc] initWithFrame:CGRectZero];
    __weak TOSetupController *bSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {

        self.agePicker.onPickerDone = ^() {
            NSString *ageLabel = [self.agePicker.currentAge valueForKey:@"name"];
            [bSelf setAgeButtonDisplay:ageLabel];
            [bSelf dismissAgePickerAnimated:YES];
        };
        CGRect ageFrame = CGRectMake(0, CGRectGetMinY(self.view.frame) + CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.agePicker.frame), CGRectGetWidth(self.agePicker.frame), CGRectGetHeight(self.agePicker.frame));
        self.agePicker.frame = ageFrame;
        [self.view addSubview:self.agePicker];
        [self dismissAgePickerAnimated:NO];
    }
    else {
        self.agePicker.onPickerDone = ^() {
            NSString *ageLabel = [self.agePicker.currentAge valueForKey:@"name"];
            [bSelf setAgeButtonDisplay:ageLabel];
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
