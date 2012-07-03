//
//  TOAppDelegate.h
//  TimeOutBuddy
//
//  Created by John Stallings on 7/2/12.
//  Copyright (c) 2012 Mobeezio, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
