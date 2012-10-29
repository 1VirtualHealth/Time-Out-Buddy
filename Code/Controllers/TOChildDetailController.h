//
//  TOChildDetailController.h
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOChild;


@interface TOChildDetailController : UIViewController

- (id)initWithChild:(TOChild *)child;



@property (nonatomic, strong) TOChild *child;

@end
