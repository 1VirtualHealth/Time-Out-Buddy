//
//  TOHelpController.m
//  TimeOutBuddy
//
//  Created by John Stallings on 8/20/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOHelpController.h"
#import <QuartzCore/QuartzCore.h>
@interface TOHelpController ()<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *helpScroller;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *slideViews;

@property BOOL isPaging;

- (IBAction)donePressed:(id)sender;
- (IBAction)pageControlPressed:(id)sender;

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
    _slideNames = @[ @"Slide01.png", @"Slide02.png", @"Slide03.png", @"Slide04.png", @"Slide05.png", @"Slide06.png", @"Slide07.png", @"Slide08.png", @"Slide09.png", @"Slide10.png", @"Slide11.png", @"Slide12.png", @"Slide13.png", @"Slide14.png", @"Slide15.png", @"Slide16.png", @"Slide17.png", @"Slide18.png", @"Slide19.png"];
    
    NSMutableArray *slides = [NSMutableArray array];
    self.helpScroller.contentSize = CGSizeMake(CGRectGetWidth(self.helpScroller.frame) * [_slideNames count], CGRectGetHeight(self.helpScroller.frame));
    for (NSInteger index = 0;index < [_slideNames count];index++) {
        CGRect imageFrame = CGRectMake(CGRectGetWidth(self.helpScroller.frame)*index,
                                       0,
                                       CGRectGetWidth(self.helpScroller.frame),
                                       CGRectGetHeight(self.helpScroller.frame));
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.autoresizingMask = UIViewAutoresizingNone;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[_slideNames objectAtIndex:index]];
        [slides addObject:imageView];
        [self.helpScroller addSubview:imageView];
    }
    self.slideViews = slides;
    self.pageControl.numberOfPages = [slides count];
    self.pageControl.hidesForSinglePage = YES;
}

- (void)adjustLayout
{
    self.helpScroller.contentSize = CGSizeMake(CGRectGetWidth(self.helpScroller.frame) * [_slideNames count], CGRectGetHeight(self.helpScroller.frame));
    for (NSInteger index = 0;index < [self.slideViews count];index++) {
        CGRect imageFrame = CGRectMake(CGRectGetWidth(self.helpScroller.frame)*index,
                                       0,
                                       CGRectGetWidth(self.helpScroller.frame),
                                       CGRectGetHeight(self.helpScroller.frame));
        UIView *subview = [self.slideViews objectAtIndex:index];
        subview.frame = imageFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adjustLayout];

}
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"rotated");
    [self adjustLayout];
}

- (IBAction)donePressed:(id)sender
{
    _onEndHelp();
}

- (IBAction)pageControlPressed:(id)sender
{
    CGRect rect = self.helpScroller.bounds;
    rect.origin.x = self.pageControl.currentPage * CGRectGetWidth(rect);
    rect.origin.y = 0;
    
    [self.helpScroller scrollRectToVisible:rect animated:YES];
    self.isPaging = YES;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.isPaging)
        return;
    
    CGFloat pageWidth = CGRectGetWidth(self.helpScroller.frame);
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isPaging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isPaging = NO;
}


@end
