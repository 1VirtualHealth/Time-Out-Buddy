//
//  TOChildrenController.h
//  TimeOutBuddy
//
//  Created by John Stallings on 10/26/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TOEndBlock)();

@interface TOChildrenController : UITableViewController

@property (nonatomic, copy) TOEndBlock onEndBlock;

@end
