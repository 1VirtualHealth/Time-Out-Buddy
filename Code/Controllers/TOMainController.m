//
//  TOMainController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOMainController.h"
#import "TOSlideManager.h"
#import "TOSlide.h"
#import "GradientButton.h"

@interface TOMainController ()

@property (nonatomic, strong) TOSlideManager *slideManager;

- (void)timeoutComplete;

@end

@implementation TOMainController

@synthesize ageGroup = _age;
@synthesize imageView = _imageView;
@synthesize slideManager = _slideManager;
@synthesize slideLabel = _slideLabel;
@synthesize endButton = _endButton;
@synthesize onEndTimeOut = _onEndTimeOut;

- (void)timeoutComplete
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Always start with the Stop sign
    self.view.backgroundColor = [UIColor redColor];
    [self.endButton useRedDeleteStyle];
    
    self.endButton.hidden = YES;
    self.slideLabel.hidden = YES;
    
    self.slideManager = [[TOSlideManager alloc] init];
    [self.slideManager setAgeGroup:self.ageGroup];
    [self.slideManager setOnTick:^(TOSlide *newSlide){
        self.imageView.image = newSlide.image;
        self.view.backgroundColor = newSlide.color;
        self.slideLabel.text = newSlide.label;
        self.slideLabel.hidden = !newSlide.label;
    }];
    [self.slideManager setOnComplete:^() {
        self.endButton.hidden = NO;
    }];
    
    [self.slideManager start];
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

- (IBAction)endTimeOutPressed:(id)sender
{
    _onEndTimeOut();
}


@end
