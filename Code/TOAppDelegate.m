//
//  TOAppDelegate.m
//  TimeOutBuddy
//
//  Created by John Stallings on 7/2/12.
//  Copyright (c) 2012 How2Connect.com, Inc. All rights reserved.
//

#import "TOAppDelegate.h"

@interface TOAppDelegate()

- (void)setupDatabase;
- (void)setupLogging;

@end

@implementation TOAppDelegate

int ddLogLevel = LOG_LEVEL_ERROR;

#pragma mark - Private methods

- (void)setupDatabase
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"TimeOutBuddy.db"];
}

- (void)setupLogging
{
#ifdef DEBUG
    ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    ddLogLevel = LOG_LEVEL_ERROR;
#endif
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDLogVerbose(@"====Logging Initialized=====");

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupDatabase];
    [self setupLogging];
    UIStoryboard *storyboard;
    if (isPad()) {
        storyboard = [UIStoryboard storyboardWithName:@"TimeoutBuddy-iPad" bundle:nil];
    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"TimeoutBuddy" bundle:nil];
    }
    
    self.rootController = [storyboard instantiateInitialViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
