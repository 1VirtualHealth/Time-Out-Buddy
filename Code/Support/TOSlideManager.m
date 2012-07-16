//
//  TOSlideManager.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/6/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOSlideManager.h"
#import "TOSlide.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioPlayer+PGFade.h"
#import "UIColor+Additions.h"
#import "NSArray+TOAdditions.h"

@interface TOSlideManager()

@property (nonatomic, strong) NSArray *colorGroups;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, strong) NSTimer *slideTimer;
@property (nonatomic, assign) NSTimeInterval slideInterval;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, assign) NSInteger slideIndex;

- (void)handleTimer:(NSTimer *)timer;

@end

@implementation TOSlideManager

@synthesize ageGroup = _ageGroup;
@synthesize images = _images;
@synthesize onTick = _onTick;
@synthesize onComplete = _onComplete;
@synthesize slideTimer = _slideTimer;
@synthesize slideInterval = _slideInterval;

@synthesize slideIndex = _slideIndex;
@synthesize colorIndex = _colorIndex;

@synthesize  colorGroups = _colorGroups;

- (id)init
{
    self = [super init];
    if (self) {
        
        NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
        self.colorGroups = [NSArray arrayWithContentsOfFile:colorPath];
        
        NSString *imagesPath = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
        self.images = [NSArray arrayWithContentsOfFile:imagesPath];
     
        NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"]];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        self.audioPlayer.numberOfLoops = -1;
        self.audioPlayer.volume = 1.0;
        
    }
    
    return self;
}

- (void)start
{
    //figure out the slide interval
    NSInteger totalDuration = [[self.ageGroup valueForKey:@"duration"] intValue];
    NSInteger displayCount = [[self.ageGroup valueForKey:@"displayCount"] intValue];
    NSInteger colorCount = [self.colorGroups count];
    
    self.slideInterval = totalDuration / ((float)displayCount * colorCount);
    NSLog(@"Setting slide interval of %1.1f for duration %d", self.slideInterval, totalDuration);
    
    self.colorIndex = 0;
    self.slideIndex = 0;
    
    [self resume];
    [self handleTimer:nil] ;// Prime the pump

}

- (void)pause
{
    [self.slideTimer invalidate];
    self.slideTimer = nil;
    [self.audioPlayer stopWithFadeDuration:2.0];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}

- (void)resume
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:[self slideInterval]
                                                       target:self
                                                     selector:@selector(handleTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
    [self.audioPlayer play];
}

- (void)stop
{
    [self pause];
    _onComplete();
}


- (void)handleTimer:(NSTimer *)timer
{
    NSLog(@"timerCalled");
    NSInteger maxSlides = [[self.ageGroup valueForKey:@"displayCount"] intValue];
    NSInteger maxColors = [self.colorGroups count];

    
    if (self.slideIndex == maxSlides) {
        self.colorIndex++;
        self.slideIndex = 0;
    }
    
    if (self.colorIndex == maxColors) {
        [self stop];
        return;
    }


    
    NSDictionary *colorGroup = [self.colorGroups objectAtIndex:self.colorIndex];
    
    UIImage *image = nil;
    NSString *label = nil;
    if(self.slideIndex == 0 && [colorGroup valueForKey:@"start"]){
        NSDictionary *startImage = [colorGroup valueForKey:@"start"];
        image = [UIImage imageNamed:[startImage valueForKey:@"fileName"]];
        label = [startImage valueForKey:@"label"];
    }
    else if (self.slideIndex == maxSlides -1 && [colorGroup valueForKey:@"finish"]) {
        NSDictionary *endImage = [colorGroup valueForKey:@"finish"];
        image = [UIImage imageNamed:[endImage valueForKey:@"fileName"]];
        label = [endImage valueForKey:@"label"];
    }
    else {
        //From the images generate the age predicate
        NSInteger age = [[self.ageGroup valueForKey:@"age"] intValue];
        NSPredicate *agePredicate = [NSPredicate predicateWithFormat:@"ageFilter == NULL OR (ageFilter.minimum <= %d AND ageFilter.maximum >= %d)", age, age];
        NSArray *filteredArray = [self.images filteredArrayUsingPredicate:agePredicate];
        
        
        NSDictionary *candidate = [filteredArray randomObject];
        image = [UIImage imageNamed:[candidate valueForKey:@"fileName"]];
        label = [candidate valueForKey:@"label"];
    }
    UIColor *color = [UIColor colorWithHexString:[colorGroup valueForKey:@"color"]];
    TOSlide *slide = [TOSlide slideWithImage:image color:color label:label];
    
    _onTick(slide);
    self.slideIndex++;

}

@end
