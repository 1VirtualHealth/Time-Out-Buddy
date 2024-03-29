//
//  ButtonGradientView.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Source: http://code.google.com/p/iphonegradientbuttons/source/browse/trunk/Classes/GradientButton.h


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GradientButton : UIButton 
{
    // These two arrays define the gradient that will be used
    // when the button is in UIControlStateNormal
    NSArray  *normalGradientColors;     // Colors
    NSArray  *normalGradientLocations;  // Relative locations
    
    // These two arrays define the gradient that will be used
    // when the button is in UIControlStateHighlighted 
    NSArray  *highlightGradientColors;     // Colors
    NSArray  *highlightGradientLocations;  // Relative locations
    
    // This defines the corner radius of the button
    CGFloat         cornerRadius;
    
    // This defines the size and color of the stroke
    CGFloat         strokeWeight;
    UIColor         *strokeColor;
    
@private
    CGGradientRef   normalGradient;
    CGGradientRef   highlightGradient;
}
@property (nonatomic, retain) NSArray *normalGradientColors;
@property (nonatomic, retain) NSArray *normalGradientLocations;
@property (nonatomic, retain) NSArray *highlightGradientColors;
@property (nonatomic, retain) NSArray *highlightGradientLocations;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat strokeWeight;
@property (nonatomic, retain) UIColor *strokeColor;
- (void)useAlertStyle;
- (void)useRedDeleteStyle;
- (void)useWhiteStyle;
- (void)useBlackStyle;
- (void)useWhiteActionSheetStyle;
- (void)useBlackActionSheetStyle;
- (void)useSimpleOrangeStyle;
- (void)useGreenConfirmStyle;

@end