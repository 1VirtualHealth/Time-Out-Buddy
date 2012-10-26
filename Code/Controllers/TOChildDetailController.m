//
//  TOChildDetailController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOChildDetailController.h"

@interface TOChildDetailController ()

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end

@implementation TOChildDetailController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (IBAction)cancelButtonPressed:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:nil];
}

@end
