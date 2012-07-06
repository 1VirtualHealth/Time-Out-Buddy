//
//  UIColor+Additions.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/9/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//  Category sourced from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string


#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
