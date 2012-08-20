//
//  TOHelpController.h
//  TimeOutBuddy
//
//  Created by John Stallings on 8/20/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EndHelpBlock)();


@interface TOHelpController : UIViewController


@property (nonatomic, copy)  EndHelpBlock onEndHelp;

@end
