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
#import "NSMutableArray+TOAdditions.h"
#import "NSArray+TOAdditions.h"

#define kAudioStartupDelay 2.0
#define kAudioTimerDelay 30.0
#define kAudioLastMessage 5
#define kDimmingVolume 0.2

@interface TOSlideManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *colorGroups;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *unusedImages;

@property (nonatomic, strong) NSArray *slides;
@property (nonatomic, strong) NSDictionary *audio;

@property (nonatomic, strong) NSTimer *audioTimer;
@property (nonatomic, strong) NSTimer *slideTimer;
@property (nonatomic, strong) NSTimer *middleTimer;

@property (nonatomic, assign) NSTimeInterval slideInterval;
@property (nonatomic, assign) NSTimeInterval timeoutDuration;


@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *backgroundPlayer;

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, assign) NSInteger slideIndex;
@property (nonatomic, assign) NSInteger slideCount;

- (void)handleTimer:(NSTimer *)timer;
- (void)middleAudioTimer:(NSTimer *)timer;

- (void)loadAudio;
- (void)loadSlideDeck;

@property (nonatomic, strong) NSMutableArray *slideDeck;

@end




@implementation TOSlideManager


- (void)loadAudio
{
    NSString *audioPath  = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"plist"];
    self.audio = [NSDictionary dictionaryWithContentsOfFile:audioPath];
    
    NSString *backgroundAudio = [self.audio valueForKey:@"background"];
    NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:backgroundAudio ofType:nil]];
    self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    self.backgroundPlayer.numberOfLoops = -1;
    self.backgroundPlayer.volume = 1.0;
}

- (void)loadSlideDeck
{
    /* Load up all the Colors */
    NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    NSDictionary *colors = [NSDictionary dictionaryWithContentsOfFile:colorPath];
    self.colorGroups = [colors valueForKey:@"colors"];
    
    NSTimeInterval groupDuration = (NSTimeInterval)self.timeoutDuration/[self.colorGroups count];
    
    /* Load up all the images for populating into the slides */
    NSString *imagesPath = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
    NSArray *allImages = [NSArray arrayWithContentsOfFile:imagesPath];
    NSInteger age = [[self.ageGroup valueForKey:@"age"] intValue];
    NSPredicate *agePredicate = [NSPredicate predicateWithFormat:@"ageFilter == NULL OR (ageFilter.minimum <= %d AND ageFilter.maximum >= %d)", age, age];
    self.images = [allImages filteredArrayUsingPredicate:agePredicate];
    self.unusedImages = [NSMutableArray arrayWithArray:self.images];
    
    NSMutableArray *deck = [NSMutableArray array];
    /* Start to populate the slide deck */
    for(NSDictionary *colorGroup in self.colorGroups)
    {
        UIColor *color = [UIColor colorWithHexString:[colorGroup valueForKey:@"color"]];
        
        //First find out if we have a start slide to show and calculate how long to show it
        NSDictionary *start = [colorGroup valueForKey:@"start"];
        NSTimeInterval timeRemaining = groupDuration;
        if (start) {
            NSString *imageName = [start valueForKey:@"fileName"];
            NSString *label = [start valueForKey:@"label"];
            NSTimeInterval duration = [[start valueForKey:@"duration"] doubleValue];
            if (duration > groupDuration) duration = groupDuration;
            TOSlide *slide = [TOSlide slideWithImageName:imageName color:color label:label duration:duration];
            [deck addObject:slide];
            
            timeRemaining -= duration;
        }
        //Then figure out the remaining time and the desired rate and calculate a real rate
        if (timeRemaining > 0) {
            NSInteger rate = [[colorGroup valueForKey:@"rate"] intValue];
            NSInteger slideCount = floor(timeRemaining/rate);
            NSTimeInterval interval = (NSTimeInterval)timeRemaining/slideCount;
            
            //Add remaining slides to the deck
            while ( slideCount--) {
                NSDictionary *candidate = [self.unusedImages popRandomObject];
                NSString *image = [candidate valueForKey:@"fileName"];
                NSString *label = [candidate valueForKey:@"label"];
                TOSlide *slide = [TOSlide slideWithImageName:image color:color label:label duration:interval];
                [deck addObject:slide];
            }
        }
        

        
    }
    
    //Push the finish slide onto the deck for now
    //HACK : to satisfy the need to only show the GO image at the very end, rather than as the last slide
    NSDictionary *finish = [colors valueForKey:@"finish"];
    if (finish) {
        NSString *image = [finish valueForKey:@"fileName"];
        NSString *label = [finish valueForKey:@"label"];
        UIColor *color = [UIColor colorWithHexString:[finish valueForKey:@"color"]];
        TOSlide *slide = [TOSlide slideWithImageName:image color:color label:label duration:0];
        [deck addObject:slide];
    }
    
    self.slideDeck = deck;

}

- (id)init
{
    self = [super init];
    if (self) {
        self.colorIndex = 0;
        self.slideIndex = 0;
        

    }
    
    return self;
}

- (NSMutableArray *)unusedImages {
    if ([_unusedImages count] == 0) {
        _unusedImages = [NSMutableArray arrayWithArray:self.images];
    }
    
    return _unusedImages;
}

- (void)start
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.timeoutDuration = [[self.ageGroup valueForKey:@"duration"] intValue];

    [self loadSlideDeck];
    [self loadAudio];
    
    [self handleTimer:nil] ;// Prime the pump

    [self.backgroundPlayer play];
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:kAudioStartupDelay target:self selector:@selector(firstAudioRun:) userInfo:nil repeats:NO];
    self.middleTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutDuration/2 target:self selector:@selector(middleAudioTimer:) userInfo:nil repeats:YES];
}



- (void)stop
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (self.slideTimer) {
        [self.slideTimer invalidate];
        self.slideTimer = nil;
    }
    if (self.audioTimer) {
        [self.audioTimer invalidate];
        self.audioTimer = nil;
    }
    
    if (self.middleTimer) {
        [self.middleTimer invalidate];
        self.middleTimer = nil;
    }
    
    
    [self.backgroundPlayer stopWithFadeDuration:2.0];

    NSString *audioPath = [self.audio valueForKey:@"finish"];
    NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioPath ofType:nil]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0;
    
    [self.audioPlayer play];

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
        [self.backgroundPlayer fadeToVolume:kDimmingVolume duration:1.0];
        
        [self.audioPlayer play];
    }
    else {
        
    }
    
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:kAudioTimerDelay target:self selector:@selector(audioInterval:) userInfo:nil repeats:YES];
    
}

- (void)middleAudioTimer:(NSTimer *)timer
{
    NSString *middleAudio = [self.audio valueForKey:@"middle"];
    if (middleAudio) {
        NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:middleAudio ofType:nil]];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0;
        
        self.audioPlayer.delegate = self;
        [self.backgroundPlayer fadeToVolume:kDimmingVolume duration:1.0];
        
        [self.audioPlayer play];
    }
}

- (void)audioInterval:(NSTimer *)timer
{ 
    NSString *audioPath = [[self.audio valueForKey:@"general"] randomObject];
    NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:audioPath ofType:nil]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0;
    self.audioPlayer.delegate = self;
    self.backgroundPlayer.volume= kDimmingVolume;
    
    [self.audioPlayer play];

}

- (void)handleTimer:(NSTimer *)timer
{
    TOSlide *slide = nil;
    if ([self.slideDeck count] > 0) {
        slide = [self.slideDeck objectAtIndex:0];
        [self.slideDeck removeObjectAtIndex:0];
    }
    if (slide) {
        _onTick(slide);
        self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:slide.duration target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    }
    else {
        [self stop];
    }


}

#pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ( player == self.audioPlayer) {
        [self.backgroundPlayer fadeToVolume:1.0 duration:1.0];
    }
    
}

@end
