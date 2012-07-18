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


#define kAudioStartupDelay 5.0
#define kDimmingVolume 0.3

@interface TOSlideManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *colorGroups;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, strong) NSDictionary *audio;

@property (nonatomic, strong) NSTimer *audioTimer;
@property (nonatomic, strong) NSTimer *slideTimer;

@property (nonatomic, assign) NSTimeInterval slideInterval;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *backgroundPlayer;

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, assign) NSInteger slideIndex;
@property (nonatomic, assign) NSInteger slideCount;

- (void)handleTimer:(NSTimer *)timer;
- (void)calculateSlideInterval;

@end




@implementation TOSlideManager

@synthesize ageGroup = _ageGroup;
@synthesize images = _images;
@synthesize onTick = _onTick;
@synthesize onComplete = _onComplete;
@synthesize slideTimer = _slideTimer;
@synthesize audioTimer = _audioTimer;

@synthesize slideInterval = _slideInterval;

@synthesize slideCount = _slideCount;
@synthesize slideIndex = _slideIndex;
@synthesize colorIndex = _colorIndex;

@synthesize  colorGroups = _colorGroups;
@synthesize audio = _audio;

@synthesize audioPlayer = _audioPlayer;
@synthesize backgroundPlayer = _backgroundPlayer;

- (id)init
{
    self = [super init];
    if (self) {
        
        NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
        self.colorGroups = [NSArray arrayWithContentsOfFile:colorPath];
        
        NSString *imagesPath = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
        self.images = [NSArray arrayWithContentsOfFile:imagesPath];
     
        
        NSString *audioPath  = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"plist"];
        self.audio = [NSDictionary dictionaryWithContentsOfFile:audioPath];
        
        NSString *backgroundAudio = [self.audio valueForKey:@"background"];
        
        NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:backgroundAudio ofType:nil]];
        self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        self.backgroundPlayer.numberOfLoops = -1;
        self.backgroundPlayer.volume = 1.0;
        
    }
    
    return self;
}


- (void)calculateSlideInterval
{

    //figure out the slide interval
    NSInteger totalDuration = [[self.ageGroup valueForKey:@"duration"] intValue];
    NSInteger colorCount = [self.colorGroups count];

    NSTimeInterval timePerColor = (NSTimeInterval)totalDuration/colorCount;
    
    NSDictionary *colorGroup = [self.colorGroups objectAtIndex:self.colorIndex];
    NSInteger rate = [[colorGroup valueForKey:@"rate"] intValue];
        
    self.slideCount = floor(timePerColor/rate);
    self.slideInterval = (NSTimeInterval)timePerColor / self.slideCount;
    
    
}

- (void)start
{
    self.colorIndex = 0;
    self.slideIndex = 0;
    [self calculateSlideInterval];

    [self resume];
    [self handleTimer:nil] ;// Prime the pump
    
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:kAudioStartupDelay target:self selector:@selector(firstAudioRun:) userInfo:nil repeats:NO];

}

- (void)pause
{
    [self.slideTimer invalidate];
    self.slideTimer = nil;
    [self.backgroundPlayer stopWithFadeDuration:2.0];
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
    [self.backgroundPlayer play];
}

- (void)stop
{
    [self pause];
    _onComplete();
}

- (void)firstAudioRun:(NSTimer *)timer
{
    self.audioTimer = nil;
    
    NSString *startAudio = [self.audio valueForKey:@"start"];
    if (startAudio) {
        NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:startAudio ofType:nil]];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0;
        
        self.audioPlayer.delegate = self;
        self.backgroundPlayer.volume = kDimmingVolume;
        
        [self.audioPlayer play];
        
    }
}

- (void)handleTimer:(NSTimer *)timer
{
    NSInteger maxColors = [self.colorGroups count];

    
    if (self.slideIndex == self.slideCount) {
        self.colorIndex++;
        
        if (self.colorIndex == maxColors) {
            [self stop];
            return;
        }
        else {
            [self calculateSlideInterval];
        
            [self.slideTimer invalidate];
            self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:self.slideInterval target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        
            self.slideIndex = 0;
        }
    }
    
    
    NSDictionary *colorGroup = [self.colorGroups objectAtIndex:self.colorIndex];
    
    UIImage *image = nil;
    NSString *label = nil;
    if(self.slideIndex == 0 && [colorGroup valueForKey:@"start"]){
        NSDictionary *startImage = [colorGroup valueForKey:@"start"];
        image = [UIImage imageNamed:[startImage valueForKey:@"fileName"]];
        label = [startImage valueForKey:@"label"];
    }
    else if (self.slideIndex == self.slideCount -1 && [colorGroup valueForKey:@"finish"]) {
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

#pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ( player == self.audioPlayer) {
        self.backgroundPlayer.volume = 1.0;
    }
    
}

@end
