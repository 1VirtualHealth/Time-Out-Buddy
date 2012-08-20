//
//  TOHelpController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 8/20/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOHelpController.h"

@interface TOHelpController ()<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *helpScroller;

- (IBAction)donePressed:(id)sender;

@end

@implementation TOHelpController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)donePressed:(id)sender
{
    _onEndHelp();
}


@end
